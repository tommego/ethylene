#ifndef ETHYLENESETTING_H
#define ETHYLENESETTING_H

#include <QObject>
#include <QSettings>
class EthyleneSetting : public QObject
{
    Q_OBJECT
public:
    explicit EthyleneSetting(QObject *parent = 0);
    ~EthyleneSetting();
    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);
    Q_INVOKABLE QVariant getValue(const QString &key, const QVariant &defaultValue = QVariant());

signals:

public slots:

private:
    QSettings *rootIni;
};

#endif // ETHYLENESETTING_H
