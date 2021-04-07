#include "DeviceManager.h"

#include <QProcess>
#include <QDir>
#include <QJsonDocument>
#include <QSslKey>

#include <QDebug>

DeviceManager::DeviceManager(QObject *parent) : QObject(parent), networkAccessManager(this)
{

}

QJsonArray DeviceManager::listDevices()
{
    QProcess *process = aresCommand("ares-setup-device", QStringList{"-F"});
    process->start();
    if (!process->waitForFinished() || process->exitStatus() != QProcess::NormalExit)
    {
        qWarning() << process->errorString();
        return QJsonArray();
    }
    QJsonDocument json = QJsonDocument::fromJson(process->readAllStandardOutput());
    delete process;
    return json.array();
}

bool DeviceManager::addDevice(QJsonObject info)
{
    QJsonValue device = info.take("device");
    QStringList argsList = QStringList{"-a", device.toString()};
    foreach(const QString& key, info.keys()) {
        argsList << "-i";
        argsList << QString("%1=%2").arg(key, info[key].toVariant().toString());
    }
    QProcess *process = aresCommand("ares-setup-device", argsList);
    process->start();
    if (!process->waitForFinished() || process->exitStatus() != QProcess::NormalExit)
    {
        qWarning() << process->errorString();
    }
    return true;
}

bool DeviceManager::downloadPrivKey(QString address, QString device, QString passphrase, PrivKeyDownloadCallback *callback)
{
    QString url = QString("http://%1:9991/webos_rsa").arg(address);
    QNetworkRequest request(url);
    QNetworkReply * reply = networkAccessManager.get(request);
    QObject::connect(reply, &QNetworkReply::errorOccurred, callback, [=](QNetworkReply::NetworkError err) {
        emit callback->errored(true, "Error fetching PrivKey");
    });
    QObject::connect(reply, &QNetworkReply::finished, callback, [=]() {
        QByteArray privKey = reply->readAll();
        QSslKey sslKey(privKey, QSsl::Rsa, QSsl::Pem, QSsl::PrivateKey, passphrase.toUtf8());
        if (sslKey.isNull())
        {
            emit callback->errored(true, "Passphrase is not correct");
            return;
        }
        QString keyFileName = QString("%1_webos").arg(device);
        QDir sshDir(QDir::home().filePath(".ssh"));
        if (!sshDir.exists()) {
            QDir::home().mkdir(".ssh");
            QFile(sshDir.absolutePath()).setPermissions(QFile::ReadOwner | QFile::WriteOwner | QFile::ExeOther);
        }
        callback->keyPath = sshDir.filePath(keyFileName);
        callback->keyFileName = keyFileName;
        callback->privKey = privKey;
        if (QFile(callback->keyPath).exists()) {
            emit callback->exists();
            return;
        }
        callback->save();
    });
    return true;
}

QProcess* DeviceManager::aresCommand(const QString &command, const QStringList &arguments)
{
    QProcess *process;
    process = new QProcess();
    QStringList fullArgs;
    fullArgs << QDir(ARES_CLI_PATH).filePath(command);
    fullArgs << arguments;
    qDebug() << fullArgs;
    process->setProgram(NODE_BIN);
    process->setArguments(fullArgs);
    return process;
}

PrivKeyDownloadCallback::PrivKeyDownloadCallback(QObject *parent): QObject(parent)
{

}

void PrivKeyDownloadCallback::answerExists(bool overwrite)
{
    if (!overwrite) {
        emit errored(false, "PrivKey already exists");
        return;
    }
    save();
}

void PrivKeyDownloadCallback::save()
{
    QFile file(keyPath);
    if (!file.open(QIODevice::WriteOnly)){
        emit errored(true, "Failed to open key file");
        return;
    }
    file.write(privKey);
    file.flush();
    file.close();
    emit finished(keyFileName);
}
