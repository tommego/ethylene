#include <QApplication>
#include "global.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

//    MysqlServer server;

//    qmlRegisterType<SerialPortManager>("SerialPortManager",1,0,"SerialPortManager");
//    server.rootContext()->setContextProperty("server", &server);

//    server.load(QUrl(QStringLiteral("qrc:/login.qml")));

    openLoginWindow();

    return app.exec();
}
