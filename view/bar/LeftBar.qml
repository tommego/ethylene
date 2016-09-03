import QtQuick 2.0
import "../Widget"

Item {

    property string bgColor: "#344750"
    property int currentIndex: 0
    signal indexChanged(var index);
    onCurrentIndexChanged: indexChanged(currentIndex)

    ListModel{
        id:menuList
        ListElement{
            imgSrc : "qrc:/imgs/icons/date-input.png"
            selected : true
            title : "数据导入"
        }
        ListElement{
            imgSrc : "qrc:/imgs/icons/search.png"
            selected : false
            title : "数据查询"
        }
        ListElement{
            imgSrc : "qrc:/imgs/icons/compare.png"
            selected : false
            title : "管管比较"
        }
        ListElement{
            imgSrc : "qrc:/imgs/icons/diagnosis.png"
            selected : false
            title : "结焦诊断"
        }
        ListElement{
            imgSrc : "qrc:/imgs/icons/presure.png"
            selected : false
            title : "压力数据导入"
        }
        ListElement{
            imgSrc : "qrc:/imgs/icons/user.png"
            selected : false
            title : "用户管理"
        }
        ListElement{
            imgSrc : "qrc:/imgs/icons/setting.png"
            selected : false
            title : "参数信息"
        }
        ListElement{
            imgSrc : "qrc:/imgs/icons/message.png"
            selected : false
            title : "版本信息"
        }
    }

    //background
    Rectangle{
        id:bg
        anchors.fill: parent
        color: bgColor
    }

    Column{
        anchors.fill: parent
        Item{
            width: parent.width
            height: 80
            Image {
                source: "qrc:/imgs/icons/logo.png"
                anchors.centerIn: parent
            }
        }
        Item{
            width: parent.width
            height: parent.height-80
            Column{
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater{
                    model: menuList
                    delegate: ImageCheckBox{
                        width: parent.width
                        height: 80
                        checked: selected
                        imgSource: imgSrc
                        text: title

                        onBntClicked: {
                            if(currentIndex === index)
                                return;
                            for(var a = 0 ; a<menuList.count ; a++){
                                if(menuList.get(a).selected){
                                    menuList.setProperty(a,"selected",false);
                                }
                            }
                            menuList.setProperty(index,"selected",true);
                            currentIndex = index;
                        }
                    }
                }
            }
        }
    }


}
