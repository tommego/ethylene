import QtQuick 2.0
import "../Widget"

Rectangle {
    id:root
    anchors.fill: parent

    Rectangle{
        anchors.centerIn: parent
        width: 500
        height: 600
        border.width: 1
        border.color: "#cccccc"
        radius: 2

        Column{
            y:60
            x:30
            spacing: 15

            Item{
                id:tubeInSettingItem
                width: tubeInSettingRow.width
                height: 60
                //tube in alert temp setting
                Row{
                    id:tubeInSettingRow
                    spacing: 15
                    anchors.verticalCenter: parent.verticalCenter
                    Image{
                        source: "qrc:/imgs/icons/icon_tube_in.png"
                    }

                    ESlider{
                        id:tubeInSlider
                        text: "入管警戒温度"
                        value: 840
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        text: tubeInSlider.value + "℃"
                        font.pixelSize: 16
                        color: "#454545"
                    }
                }
            }

            Item{
                id: tubeOutSettingItem
                width: tubeOutSettingRow.width
                height: 60
                //tube out alert temp setting
                Row{
                    id:tubeOutSettingRow
                    spacing: 15
                    anchors.verticalCenter: parent.verticalCenter
                    Image{
                        source: "qrc:/imgs/icons/icon_tube_out.png"
                    }

                    ESlider{
                        id:tubeOutSlider
                        text: "出管警戒温度"
                        value: 840
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        text: tubeOutSlider.value + "℃"
                        font.pixelSize: 16
                        color: "#454545"
                    }
                }
            }

            Item{
                id:tubeCOTSettingItem
                width: tubeCOTSettingRow.width
                height: 60
                //tube cot alert temp setting
                Row{
                    id:tubeCOTSettingRow
                    spacing: 15
                    anchors.verticalCenter: parent.verticalCenter
                    Image{
                        source: "qrc:/imgs/icons/icon_tube_cot.png"
                    }

                    ESlider{
                        id:tubeCOTSlider
                        text: "COT警戒温度"
                        value: 840
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        text: tubeCOTSlider.value + "℃"
                        font.pixelSize: 16
                        color: "#454545"
                    }
                }
            }

            Item{
                id: cycleSettingItem
                width: cycleSettingRow.width
                height: 60
                //cycle Setting
                Row{
                    id:cycleSettingRow
                    spacing: 15
                    anchors.verticalCenter: parent.verticalCenter
                    Image{
                        source: "qrc:/imgs/icons/cycle.png"
                    }

                    ESlider{
                        id:cycleSlider
                        text: "数据备份周期"
                        value: 1
                        minValue: 1
                        maxValue: 12
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text{
                        anchors.verticalCenter: parent.verticalCenter
                        text: cycleSlider.value + "个月"
                        font.pixelSize: 16
                        color: "#454545"
                    }
                }
            }
        }

        Row{
            id:dumpBntRow
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50
            x:50
            spacing: 20
            Text{
                text: "数据备份目录"
                font.pixelSize: 15
                color: "#454545"
                anchors.verticalCenter: parent.verticalCenter
            }

            Image {
                id: dumpPathButton
                source: bumpPathMa.pressed?"qrc:/imgs/icons/save_press.png":
                                             bumpPathMa.containsMouse?"qrc:/imgs/icons/save_hover.png":
                                                                       "qrc:/imgs/icons/save_normal.png"
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    id:bumpPathMa
                }
            }
        }
    }

}
