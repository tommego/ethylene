import QtQuick 2.0
import "../Widget"

Item {

    property string bgColor: "#344750"
    property int currentIndex: 0
    signal indexChanged(var index);
    property var dataModel;
//    onCurrentIndexChanged: indexChanged(currentIndex)

    function updateStatus() {
        for(var a = 0 ; a<menuList.count ; a++){
            if (a === currentIndex)
                menuList.setProperty(a,"selected",true);
            else
                menuList.setProperty(a,"selected",false);
        }
    }
    onCurrentIndexChanged: {
        updateStatus()
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
                    model: dataModel
                    delegate: ImageCheckBox{
                        width: parent.width
                        height: 80
                        checked: selected
                        imgSource: imgSrc
                        text: title

                        onBntClicked: {
                            currentIndex = index;
                            updateStatus()
                            indexChanged(currentIndex)
                        }
                    }
                }
            }
        }
    }


}
