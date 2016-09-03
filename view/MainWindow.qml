import QtQuick 2.0
import "./bar"

Item {
    id:mainWindow

    property var pages:[
        "qrc:/view/page/DataImportPage.qml",
        "qrc:/view/page/DataSearchPage.qml",
        "qrc:/view/page/TubesComparePage.qml",
        "qrc:/view/page/DiagnosePage.qml",
        "qrc:/view/page/PressureDataImportPage.qml",
        "qrc:/view/page/UserManagerPage.qml",
        "qrc:/view/page/SettingPage.qml",
        "qrc:/view/page/MessagePage.qml"

    ]

    Row{
        anchors.fill: parent
        LeftBar{
            id:leftbar
            width: 150
            height: parent.height
            onIndexChanged: {
                loader.source = pages[index]
            }
        }
        Loader{
            id:loader
            width: parent.width-leftbar.width
            height:parent.height
            source: "qrc:/view/page/DataImportPage.qml"
        }
    }
}
