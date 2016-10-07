#include "global.h"
#include <QQmlApplicationEngine>
#include <QtQml>

void openLoginWindow()
{
    QQmlApplicationEngine *engine = new QQmlApplicationEngine();
    engine->rootContext()->setContextProperty("server",MysqlServer::instance());
    engine->load(QUrl(QStringLiteral("qrc:/login.qml")));
}

void openManagerWindow()
{
    QQmlApplicationEngine *engine = new QQmlApplicationEngine();
    engine->rootContext()->setContextProperty("server",MysqlServer::instance());
    qmlRegisterType<SerialPortManager>("SerialPortManager",1,0,"SerialPortManager");
    engine->load(QUrl(QStringLiteral("qrc:/main.qml")));
}
