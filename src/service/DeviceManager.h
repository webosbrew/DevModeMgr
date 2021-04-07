#ifndef DEVICEMANAGER_H
#define DEVICEMANAGER_H

#include <QObject>
#include <QtQml>
#include <QJsonArray>
#include <QProcess>

class PrivKeyDownloadCallback;

class DeviceManager : public QObject
{
    Q_OBJECT
public:
    explicit DeviceManager(QObject *parent = nullptr);
    Q_INVOKABLE QJsonArray listDevices();
    Q_INVOKABLE bool addDevice(QJsonObject info);
    Q_INVOKABLE bool downloadPrivKey(QString address, QString device, QString passphrase, PrivKeyDownloadCallback *callback);
private:
    QProcess* aresCommand(const QString &command, const QStringList &arguments);
    QNetworkAccessManager networkAccessManager;
signals:

};

class PrivKeyDownloadCallback : public QObject
{
    Q_OBJECT
public:
    friend class DeviceManager;
    explicit PrivKeyDownloadCallback(QObject *parent = nullptr);
    Q_INVOKABLE void answerExists(bool overwrite);
signals:
    void finished(QString privateKey);
    void errored(bool alert, QString message);
    void exists();
private:
    void save();
    QString keyPath;
    QString keyFileName;
    QByteArray privKey;
};

#endif // DEVICEMANAGER_H
