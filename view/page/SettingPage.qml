import QtQuick 2.0
import "../Widget"

Rectangle {
    id:root
    anchors.fill: parent

    Rectangle{
        anchors.centerIn: parent
        width: 550
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
                        onValueChanged: tubeInTempEdit.text = value
                    }

                    PlainTextEdit{
                        id:tubeInTempEdit
                        anchors.verticalCenter: parent.verticalCenter
                        text: tubeInSlider.value
                        enabled: true
                        maxNumber: 2000
                        minNumber: 500
                        onFinished: {
                            tubeInSlider.value = text;
                        }
                    }

                    Text{
                        text: "℃"
                        font.pixelSize: 16
                        color: "#454545"
                        anchors.verticalCenter: parent.verticalCenter
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
                        onValueChanged: tubeOutTempEdit.text = value;
                    }

                    PlainTextEdit{
                        id:tubeOutTempEdit
                        anchors.verticalCenter: parent.verticalCenter
                        text: tubeOutSlider.value
                        enabled: true
                        maxNumber: 2000
                        minNumber: 500
                        onFinished: {
                            tubeOutSlider.value = text;
                        }
                    }

                    Text{
                        text: "℃"
                        font.pixelSize: 16
                        color: "#454545"
                        anchors.verticalCenter: parent.verticalCenter
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
                        onValueChanged: {
                            tubeCOTTempEdit.text = value;
                        }
                    }

                    PlainTextEdit{
                        id:tubeCOTTempEdit
                        anchors.verticalCenter: parent.verticalCenter
                        text: tubeCOTSlider.value
                        enabled: true
                        minNumber: 500
                        maxNumber: 2000
                        onFinished: {
                            tubeCOTSlider.value = text;
                        }
                    }

                    Text{
                        text: "℃"
                        font.pixelSize: 16
                        color: "#454545"
                        anchors.verticalCenter: parent.verticalCenter
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
                        onValueChanged: {
                            cycleEdit.text = value;
                        }
                    }

                    PlainTextEdit{
                        id:cycleEdit
                        anchors.verticalCenter: parent.verticalCenter
                        text: cycleSlider.value
                        enabled: true
                        minNumber: 1
                        maxNumber: 12
                        onFinished: {
                            cycleSlider.value = text;
                        }
                    }

                    Text{
                        text: "个月"
                        font.pixelSize: 16
                        color: "#454545"
                        anchors.verticalCenter: parent.verticalCenter
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
