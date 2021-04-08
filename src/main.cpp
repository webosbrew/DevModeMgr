#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QProcess>
#include <QDebug>

#include "model/DeviceListModel.h"
#include "service/DeviceManager.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);
    qmlRegisterSingletonType<DeviceManager>("DevModeMgr", 1, 0, "DeviceManager", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(engine);
        Q_UNUSED(scriptEngine);

        DeviceManager *mgr = new DeviceManager();
        return mgr;
    });
    qmlRegisterType<DeviceListModel>("DevModeMgr", 1, 0, "DeviceListModel");
    qmlRegisterType<PrivKeyDownloadCallback>("DevModeMgr", 1, 0, "PrivKeyDownloadCallback");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
