import QtQuick 2.0
import "../Widget"
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id:root
    anchors.fill: parent
    property var searchDatas:[]
    property int currentGroup: 0

    //test
    Component.onCompleted: {
        for(var a=0;a<12;a++){
            var tubeNum = a+1;
            var searchData = {};
            var datasInfo = [];

            for(var b=0;b<100;b++){
                var sdata = {};
                sdata.tubeInTime = "16/09/01 22:22:22";
                sdata.tubeInTemp = 888;

                sdata.tubeOutTime = "16/09/01 22:22:22";
                sdata.tubeOutTemp = 888;

                sdata.tubeCOTTime = "16/09/01 22:22:22";
                sdata.tubeCOTTemp = 888;

                datasInfo.push(sdata);
            }

            searchData.datasInfo = datasInfo;
            searchData.tubeNum = tubeNum;

            searchDatas.push(searchData);
        }
        searchDatasRepeator.model = searchDatas;

        datalistcontent.height = (searchDatas[0].datasInfo.length+1)*20 + 25
//        console.log(searchDatas[0].datasInfo.length);
    }


    Column{
        id:maincol
        anchors.fill: parent
        //top bar
        Rectangle{
            id:topBar
            width: root.width
            height: 80
            color: "#ccf4f7"

            //bnts
            Row{
                id:bntRow
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 100
                spacing: 30
                RoundIconButton{
                    id:searchbnt
                    imgSrc: "qrc:/imgs/icons/search_small.png"
                    text: "查询"
                    bgColor: "#41ccdc"
                    width: 120
                    height: 35
                }
                RoundIconButton{
                    id:exportbnt
                    imgSrc: "qrc:/imgs/icons/output.png"
                    text: "导出数据"
                    width: 120
                    height: 35
                }
            }

            //date pickers
            Column{
                id:datePickerCol
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: bntRow.left
                anchors.rightMargin: 50
                spacing: 10
                Item{
                    id: fromDatepickerItem
                    width: fromDatepickerRow.width
                    height: 20
                    Row{
                        id:fromDatepickerRow
                        Item{
                            width: 60
                            height: 20
                            Text{
                                anchors.centerIn: parent
                                text: "从时间:"
                                font.pixelSize: 16
                                color: "#333333"
                            }
                        }
                        DatePicker{
                            id:fromDatePicker
                        }
                    }
                }

                Item{
                    id: toDatepickerItem
                    width: toDatepickerRow.width
                    height: 20
                    Row{
                        id:toDatepickerRow
                        Item{
                            width: 60
                            height: 20
                            Text{
                                anchors.centerIn: parent
                                text: "到时间:"
                                font.pixelSize: 16
                                color: "#333333"
                            }
                        }
                        DatePicker{
                            id:toDatePicker
                        }
                    }
                }

            }

            //forance chooser
            Row{
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: datePickerCol.left
                anchors.rightMargin: 50
                spacing: 10
                Text{
                    text: "炉号:"
                    font.pixelSize: 20
                    color: "#454545"
                    anchors.verticalCenter: parent.verticalCenter
                }

                ForanceNumComboBox{
                    id:foranceNumComboBox
                }
            }

            //line
            Rectangle{
                width: parent.width
                height: 1
                color: "#999999"
                anchors.bottom: parent.bottom
            }

        }

        //content
        Rectangle{
            id: content
            width: root.width
            height: root.height - topBar.height-40

            ScrollView{
                width: parent.width
                height: parent.height
                style: ScrollViewStyle{
                    decrementControl: Item{

                    }
                    incrementControl: Item{

                    }
                    corner: Item{

                    }
                }

                Item{
                    id:datalistcontent
                    width: datasRow.width
                    height: 100
                    Row{
                        id:datasRow
                        Repeater{
                            id:searchDatasRepeator
                            delegate: TubeInfoList{
                                id:infoDelegate
                                tubeNum: modelData.tubeNum
                                datasInfo: modelData.datasInfo
                            }
                        }
                    }
                    Rectangle{
                        width: 1
                        height: parent.height
                        color: "#999999"
                    }
                }
            }
        }

        //indicators
        Rectangle{
            width: parent.width
            height: 40
            color: "#999999"
            Row{
                height: 38
                spacing: 1
                anchors.centerIn: parent
                Repeater{
                    model: 4
                    delegate: Rectangle{
                        width: root.width/4-5
                        height: 38
                        color: currentGroup === index?"#41ccdc":"#344750"
                        Text{
                            anchors.centerIn: parent
                            text: "第"+(index+1)+"组"
                            color: "#ffffff"
                            font.pixelSize: 20
                        }

                        MouseArea{
                            anchors.fill: parent
                            onClicked: currentGroup = index
                        }
                    }
                }
            }
        }
    }
}
