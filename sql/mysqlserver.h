#ifndef MYSQLSERVER_H
#define MYSQLSERVER_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QDateTime>
#include <QVariant>
#include <string>
#include <QList>
#include <QDebug>
#include <QMap>
#include <QDateTime>
#include <iterator>
#include <QTime>
#include <QWidget>
#include <QPushButton>
#include <QDebug>
#include <QFile>
#include <QFileDialog>
#include <QTextStream>
#include <QAxObject>
#include <QGridLayout>
#include <QString>
#include <QStringList>
#include <QDir>
#include <QFileInfo>
#include <QFileInfoList>
#include <windows.h>
#include <QJsonArray>
#include <QJsonObject>
#include <QtConcurrent>
#include <QSettings>


//存了乙烯入管 出管 COT 的48 根管的温度，时间结构体
struct ethlene_databases{
    //炉号
    int forenceNum[48];
    int forenceNum1[48];
    int forenceNum2[48];

    //各个管对应的时间
    //入管时间数组
    QDateTime time[48];
    //出管时间数组
    QDateTime time1[48];
    //COT管时间数组
    QDateTime time2[48];

    //各个管对应的温度
    //入管温度数组
    int tube_in_temps[48];
    //出管温度数组
    int tube_out_temps[48];
    //COT温度数组
    int cot_temp[48];
};

//简单数据结构，温度，时间
struct datas_time{
    int temp;
    QDateTime time;
};

class MysqlServer : public QObject
{
    Q_OBJECT
public:
    explicit MysqlServer(QObject *parent = 0);
    static MysqlServer* instance();
    //插入数据到数据库中
    Q_INVOKABLE void pushDatas(QString tubeNum,//炉号
                               QString forunNum,//管号
                               QString location,//位置（tube in ,tube out ,tube cot)
                               QString temp,//温度
                               QString dataTime//时间
                               );
    //计算日平均温度处理算法
    void mdeal_with(QList<datas_time> *mdt);
    //进行时间排序
    void sortData(QList<datas_time> *mdt);
    //管管比较
    Q_INVOKABLE QJsonArray compare_datas(int forunceNum,int tubeNum,QDateTime from_DateTime,QDateTime to_DateTime);
    //炉管诊断
    Q_INVOKABLE QJsonArray pressureData(int forunceNum,int tubeNum,QDateTime from_DateTime,QDateTime to_DateTime);
    //全管查询
    Q_INVOKABLE QJsonObject all_tube_show(int forunceNum,QDateTime from_DateTime, QDateTime to_DateTime);
    //获取最新的入管，出管，ＣＯＴ温度
    Q_INVOKABLE QJsonArray access_tube_in_temp();
    Q_INVOKABLE QJsonArray access_tube_out_temp();
    Q_INVOKABLE QJsonArray access_tube_cot_temp();
    //更新最新显示数据
    Q_INVOKABLE void refresh_data(){
        this->access_tube_in_temp();
        this->access_tube_out_temp();
//        this->access_tube_cot_temp();
    }
    Q_INVOKABLE void setDumpPath(QString path);

    //登陆
    Q_INVOKABLE bool login(QString userName, QString pwd, QString access);

    //用户列表
    Q_INVOKABLE QJsonArray usersList();

    //添加用户
    Q_INVOKABLE bool addUser(const QString& userName,
                             const QString& pwd,
                             const QString& access);

    //删除用户
    Q_INVOKABLE bool removeUser(const QString& userName);

    //更新用户
    Q_INVOKABLE bool updateUser(const QString& userName,
                                const QString& pwd,
                                const QString& access,
                                const QString& userId);

    //导入压强数据
    Q_INVOKABLE bool pushPressureData(const int &fn, const QJsonArray& data, const QDateTime& date);

    //获取保存图片路径
    Q_INVOKABLE QString getSaveFilePath();
    void dumpDatas();
    //导出excel
    QAxObject *excel;
    QAxObject *workbooks;
    QAxObject *workbook;
    QAxObject *worksheets;
    QAxObject *worksheet;
signals:

public slots:
    //导出EXCEl
    void exportExcel1();      //手动导出excel
    void exportExcel(QString fileName);
private:
    //当前48根管最新的温度数据保存
    ethlene_databases my_ethlene_datas;
    //新方案诊断与检测数据存放
    QList<datas_time> tube_in_test_datas;
    QList<datas_time> tube_out_test_datas;
    QList<datas_time> tube_cot_test_datas;
    QList<datas_time> pressure_test_datas;
    //全管查询后存放的数据
    QList<datas_time> tube_in_full_search_datas[48];
    QList<datas_time> tube_out_full_search_datas[48];
    QList<datas_time> tube_cot_full_search_datas[48];
    //备份数据目录
    QString mdumpPath;
    QSettings msettings;
    int m_access = 0;
};
#endif // MYSQLSERVER_H
