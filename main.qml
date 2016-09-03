import QtQuick 2.4
import QtQuick.Controls 1.3
import "./view"
import QtQuick.Window 2.0

ApplicationWindow {
    property int windowWidth: Screen.desktopAvailableWidth*0.8
    property int windowHeight: Screen.desktopAvailableHeight*0.8
    id:mainWin
    title: "乙烯裂解炉管外表面温度监测与智能分析系统"
    visible: true
    width: windowWidth
    height: windowHeight
    minimumHeight: windowHeight
    minimumWidth: windowWidth

    //Main Window
    MainWindow{
        anchors.fill: parent
    }
}
