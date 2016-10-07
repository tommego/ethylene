#ifndef SERIALPORTMANAGER_H
#define SERIALPORTMANAGER_H

#include <QObject>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QString>
#include <QList>
#include <QtDebug>
#include <QTimer>
class SerialPortManager : public QObject
{
    Q_OBJECT
public:
    explicit SerialPortManager(QObject *parent = 0);
    Q_INVOKABLE int getSerialPortsNum();
    Q_INVOKABLE QString getSerialPortName(int index);
    Q_INVOKABLE void setPortName(QString name);
    Q_INVOKABLE bool openSerialPort();
    Q_INVOKABLE void closeSerialPort();
    Q_INVOKABLE void writeDates(QString datas);

    Q_PROPERTY(QString revDatas READ revDatas WRITE setRevDatas NOTIFY revDatasChanged)
    QString revDatas(){
        return bufferDatas;
    }
    void setRevDatas(QString data){
        bufferDatas=data;
    }

signals:
    void readingFinish();
    void revDatasChanged();

public slots:
    void readDatas();
    void sendDatas();
private:
    QSerialPortInfo serialportInfo;
    QSerialPort seriaPort;
    QString cPortName;
    QString bufferDatas;
    QTimer sendTimer;
    int dataSendTimes=0;
    QSerialPort serialSender;
};

#endif // SERIALPORTMANAGER_H
