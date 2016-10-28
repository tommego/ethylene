#include "global.h"
#include <QQmlApplicationEngine>
#include <QtQml>
#include "./setting/ethylenesetting.h"
void openLoginWindow()
{
    EthyleneSetting *ESINI=new EthyleneSetting();
    QQmlApplicationEngine *engine = new QQmlApplicationEngine();
    engine->rootContext()->setContextProperty("ESINI",ESINI);
    engine->rootContext()->setContextProperty("server",MysqlServer::instance());
    engine->load(QUrl(QStringLiteral("qrc:/login.qml")));
}

void openManagerWindow()
{
    EthyleneSetting *ESINI=new EthyleneSetting();
    QQmlApplicationEngine *engine = new QQmlApplicationEngine();
    engine->rootContext()->setContextProperty("server",MysqlServer::instance());
    engine->rootContext()->setContextProperty("ESINI",ESINI);
    qmlRegisterType<SerialPortManager>("SerialPortManager",1,0,"SerialPortManager");
    engine->load(QUrl(QStringLiteral("qrc:/main.qml")));
}
