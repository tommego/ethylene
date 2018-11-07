import QtQuick 2.0
import "./bar"
import "./page"
import QtQml.Models 2.11
import QtQuick.Controls 2.4
//功能选择栏
Item {
    id:mainWindow

    property var pages:[]
    ListModel{
        id:menuList
    }
    Component.onCompleted: {

        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/date-input.png",
                            "selected":true,
                            "title":"数据导入",
                            "content":"qrc:/view/page/DataImportPage.qml"
                        });

        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/search.png",
                            "selected":false,
                            "title":"数据查询",
                            "content":"qrc:/view/page/DataSearchPage.qml"
                        });
        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/compare.png",
                            "selected":false,
                            "title":"管管比较",
                            "content":"qrc:/view/page/TubesComparePage.qml"
                        });
        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/diagnosis.png",
                            "selected":false,
                            "title":"结焦诊断",
                            "content":"qrc:/view/page/DiagnosePage.qml"
                        });
        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/presure.png",
                            "selected":false,
                            "title":"压力数据导入",
                            "content":"qrc:/view/page/PressureDataImportPage.qml"
                        });
        if(server.currentUserAccess === 1)
            menuList.append({
                                "imgSrc":"qrc:/imgs/icons/user.png",
                                "selected":false,
                                "title":"用户管理",
                                "content":"qrc:/view/page/UserManagerPage.qml"
                            });
        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/setting.png",
                            "selected":false,
                            "title":"参数信息",
                            "content":"qrc:/view/page/SettingPage.qml"
                        });
        menuList.append({
                            "imgSrc":"qrc:/imgs/icons/message.png",
                            "selected":false,
                            "title":"版本信息",
                            "content":"qrc:/view/page/MessagePage.qml"
                        });
    }

    Row{
        anchors.fill: parent
        LeftBar{
            id:leftbar
            width: 150
            height: parent.height
            dataModel: menuList
            onIndexChanged: {
//                loader.source = menuList.get(index).content
                pageListView.positionViewAtIndex(index, ListView.Beginning)
            }
        }
        ListView{
            id:pageListView
            ObjectModel{
                id: viewModel
                DataImportPage{width: pageListView.width; height: pageListView.height}
                DataSearchPage{width: pageListView.width; height: pageListView.height}
                TubesComparePage{width: pageListView.width; height: pageListView.height}
                DiagnosePage{width: pageListView.width; height: pageListView.height}
                PressureDataImportPage{width: pageListView.width; height: pageListView.height}
                UserManagerPage{width: pageListView.width; height: pageListView.height}
                SettingPage{width: pageListView.width; height: pageListView.height}
                MessagePage{width: pageListView.width; height: pageListView.height}
            }
            highlightRangeMode: ListView.StrictlyEnforceRange
            model: viewModel
            currentIndex: 0
            width: parent.width-leftbar.width
            height:parent.height
            snapMode: ListView.SnapOneItem
            Component.onCompleted: {
                positionViewAtIndex(0, ListView.Beginning)
            }
            onCurrentIndexChanged: {
                leftbar.currentIndex = currentIndex
            }
        }
    }
}
