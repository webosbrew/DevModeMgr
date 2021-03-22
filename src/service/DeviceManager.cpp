#include "DeviceManager.h"

#include <QProcess>
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
    QStringList fullArgs;
    fullArgs << QDir(ARES_CLI_PATH).filePath(command);
    fullArgs << arguments;
    process->setProgram(NODE_BIN);
    process->setArguments(fullArgs);
    return process;
}
