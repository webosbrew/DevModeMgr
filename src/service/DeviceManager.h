#ifndef DEVICEMANAGER_H
#define DEVICEMANAGER_H

#include <QObject>
#include <QtQml>
#include <QJsonArray>
#include <QProcess>

class DeviceManager : public QObject
{
    Q_OBJECT
public:
    explicit DeviceManager(QObject *parent = nullptr);
    Q_INVOKABLE QJsonArray listDevices();
private:
    QProcess* aresCommand(const QString &command, const QStringList &arguments);
signals:

};

#endif // DEVICEMANAGER_H
