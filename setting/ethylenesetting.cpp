#include "ethylenesetting.h"
#include <QDebug>

EthyleneSetting::EthyleneSetting(QObject *parent) : QObject(parent)
{
    rootIni=new QSettings("./Ethylene",QSettings::IniFormat);
}

EthyleneSetting::~EthyleneSetting()
{
    delete rootIni;
}

void EthyleneSetting::setValue(const QString &key, const QVariant &value)
{
    rootIni->setValue (key,value);
    rootIni->sync ();
}

QVariant EthyleneSetting::getValue(const QString &key, const QVariant &defaultValue)
{
    rootIni->sync ();
    qDebug()<<"K:  "<<key<<"D:  "<<defaultValue;
    return rootIni->value (key,defaultValue);
}
