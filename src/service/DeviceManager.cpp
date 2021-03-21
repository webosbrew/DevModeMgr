#include "DeviceManager.h"

#include <QProcess>
#include <QProcessEnvironment>
#include <QDir>
#include <QJsonDocument>

#include <QDebug>

DeviceManager::DeviceManager(QObject *parent) : QObject(parent)
{

}

QJsonArray DeviceManager::listDevices()
{
    QProcessEnvironment sysenv = QProcessEnvironment::systemEnvironment();
    QProcess *process = aresCommand("ares-setup-device", QStringList{"-F"});
    process->start();
    if (!process->waitForFinished())
    {
        qWarning() << process->errorString();
        return QJsonArray();
    }
    QJsonDocument json = QJsonDocument::fromJson(process->readAllStandardOutput());
    delete process;
    return json.array();
}

QProcess* DeviceManager::aresCommand(const QString &command, const QStringList &arguments)
{
    QProcess *process;
    process = new QProcess();
#ifdef Q_OS_WIN
    QProcessEnvironment sysenv = QProcessEnvironment::systemEnvironment();
    QStringList fullArgs;
    QString sdkBinPath = sysenv.value("WEBOS_CLI_TV");
    if (!sdkBinPath.isEmpty()) {
        fullArgs << "/c";
        fullArgs << QDir(sdkBinPath).filePath(command);
    }
    fullArgs << arguments;
    process->setProgram("cmd");
    process->setArguments(fullArgs);
#else
    process->setProgram(command);
    process->setArguments(arguments);
#endif
    return process;
}
