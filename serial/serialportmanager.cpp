#include "serialportmanager.h"
#include <QDebug>

SerialPortManager::SerialPortManager(QObject *parent) : QObject(parent)
{
//    this->cPortName="COM3";
    //预防有些设备没有串口的情况
    if(this->serialportInfo.availablePorts().count()>0){
        this->cPortName=serialportInfo.availablePorts().at(0).portName();
    }
    this->seriaPort.setPortName(this->cPortName);
    this->seriaPort.setBaudRate(115200);

    this->sendTimer.setInterval(100);

    connect(&seriaPort,SIGNAL(readyRead()),this,SLOT(readDatas()));
    connect(&sendTimer,SIGNAL(timeout()),this,SLOT(sendDatas()));

}

int SerialPortManager::getSerialPortsNum(){
    return serialportInfo.availablePorts().count();
}
QString SerialPortManager::getSerialPortName(int index){
    if(index<serialportInfo.availablePorts().count()){
        return serialportInfo.availablePorts().at(index).portName();
    }
    else
        return "null";
}
void SerialPortManager::setPortName(QString name){
    this->seriaPort.setPortName(name);
    this->cPortName=name;
    qDebug()<<"current port :"<<cPortName<<cPortName.length()<<endl;
}
void SerialPortManager::readDatas(){
    this->seriaPort.waitForReadyRead(500);
    bufferDatas+=seriaPort.readAll().data();
    readingFinish();
    revDatasChanged();
}
//打开串口
bool SerialPortManager::openSerialPort(){
    return this->seriaPort.open(QIODevice::ReadWrite);
}
//关闭串口
void SerialPortManager::closeSerialPort(){
    this->seriaPort.close();
}
//写入数据
void SerialPortManager::writeDates(QString datas){
    qDebug()<<this->seriaPort.portName()<<"       "<<this->seriaPort.baudRate()<<endl;
    serialSender.setPortName(this->seriaPort.portName());
    serialSender.setBaudRate(this->seriaPort.baudRate());
    qDebug()<<serialSender.open(QIODevice::ReadWrite);
    sendTimer.start();
}
void SerialPortManager::sendDatas(){
    //连续发送十次关闭数据发送触发器
    if(this->dataSendTimes>=20){
        this->sendTimer.stop();
        this->dataSendTimes=0;
//        this->serialSender.close();
        closeSerialPort();
        return;
    }

    //计数器，连续发送十次关闭数据发送触发器
    this->dataSendTimes++;


    //发送数据

    QString datas="Data_Receive_Success!";
    QByteArray data=datas.toLocal8Bit();
//    this->serialSender.write(data);
    qDebug()<<"falele1"<<seriaPort.write(data)<<endl;
    qDebug()<<"falele"<<this->serialSender.write(data)<<endl;
    this->serialSender.waitForBytesWritten(100);

}
