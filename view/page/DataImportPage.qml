import QtQuick 2.0
import "../bar"
import "../Widget"
import QtCharts 2.1
import QtQml.Models 2.2

Item {
    id:root
    anchors.fill: parent
    property int currentFornace : 0
    property int currentGroup: 0
    property int currentDisplayState:0
    property var furnaces:[
        "H110","H111","H112","H113","H114","H115","H116","H117","H118","H119","H120"
    ]

    Column{
        anchors.fill: parent
        //top bar
        Rectangle{
            id:topBar
            width: parent.width
            height: 50
            color: "#eef4f7"
            //fornaces
            Row{
                anchors.centerIn: parent
                Repeater{
                    model: furnaces
                    delegate:Item{
                        width: 80
                        height: topBar.height
                        Rectangle{
                            anchors.fill: parent
                            color: "#11000000"
                            radius: 2
                            opacity: ma.containsMouse?1:0
                            Behavior on opacity {
                                PropertyAnimation{
                                    properties: "opacity"
                                    duration: 150
                                }
                            }
                        }

                        Text{
                            text: modelData
                            font.weight: index === currentFornace?60:55
                            font.bold: index === currentFornace
                            font.pixelSize: 15
                            anchors.centerIn: parent
                            font.family: "软雅黑体"
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: currentFornace = index
                            hoverEnabled: true
                            id:ma
                        }
                        Rectangle{
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 5
                            color: "#00c5dc"
                            visible: currentFornace === index
                        }
                    }
                }
            }

            //line
            Rectangle{
                anchors.bottom: parent.bottom
                width: parent.width
                height: 2
                color: Qt.darker("#eef4f7",1.1)
            }
        }

        //content
        Rectangle{
            id:content
            width: parent.width
            height: parent.height-topBar.height
            color: "#ffffff"
            ListView{
                id:chartlist
                width: parent.width-80
                height: parent.height-80
                anchors.centerIn: parent
                clip: true
                enabled: false
                Component.onCompleted: {
                    // unknown problem
                    currentDisplayState = 1;
                    currentDisplayState = 0;
                }

                highlightRangeMode:ListView.StrictlyEnforceRange
                snapMode: ListView.SnapOneItem
                orientation: ListView.Vertical
                highlightMoveDuration:350
                currentIndex: currentDisplayState

                model: ObjectModel{
                    //linear chart
                    Item{
                        width: chartlist.width
                        height: chartlist.height
                        //charts
                        ChartView{
                            width: chartlist.width
                            height: chartlist.height
                            anchors.centerIn: parent
                            antialiasing: true
                            id:linearChart

                            ValueAxis {
                                id: axisX
                                min: 1
                                max: 12
                                tickCount: 12
                                labelFormat: "%.0f"
                            }

                            ValueAxis {
                                id: axisY
                                min: 700
                                max: 1100
                                labelFormat: "%.0f"
                            }
                            AreaSeries {
                                id:tubeOutSeries
                                name: "出管温度"
                                color: "#66ffff66"
                                borderColor: "#333333"
                                borderWidth: 1
                                axisX: axisX
                                axisY: axisY
                                upperSeries: LineSeries {
                                    id:tubeOutLine
                                    XYPoint { x: 1; y: 944 }
                                    XYPoint { x: 2; y: 956 }
                                    XYPoint { x: 3; y: 936 }
                                    XYPoint { x: 4; y: 946 }
                                    XYPoint { x: 5; y: 956 }
                                    XYPoint { x: 6; y: 936 }
                                    XYPoint { x: 7; y: 940 }
                                    XYPoint { x: 8; y: 944 }
                                    XYPoint { x: 9; y: 943 }
                                    XYPoint { x: 10; y: 950 }
                                    XYPoint { x: 11; y: 948 }
                                    XYPoint { x: 12; y: 960 }
                                }
                                lowerSeries: tubeInLine
                            }
                            AreaSeries {
                                id:tubeInSeries
                                name: "入管温度"
                                color: "#66ff5645"
                                borderColor: "#333333"
                                borderWidth: 1
                                axisX: axisX
                                axisY: axisY
                                upperSeries: LineSeries {
                                    id:tubeInLine
                                    XYPoint { x: 1; y: 880 }
                                    XYPoint { x: 2; y: 875 }
                                    XYPoint { x: 3; y: 870 }
                                    XYPoint { x: 4; y: 875 }
                                    XYPoint { x: 5; y: 873 }
                                    XYPoint { x: 6; y: 882 }
                                    XYPoint { x: 7; y: 871 }
                                    XYPoint { x: 8; y: 876 }
                                    XYPoint { x: 9; y: 884 }
                                    XYPoint { x: 10; y: 880 }
                                    XYPoint { x: 11; y: 877 }
                                    XYPoint { x: 12; y: 875 }
                                }
                                lowerSeries: tubeCOTLine
                            }
                            AreaSeries {
                                id:tubeCOTSeries
                                name: "COT温度"
                                color: "#660077ff"
                                borderColor: "#333333"
                                borderWidth: 1
                                axisX: axisX
                                axisY: axisY
                                upperSeries: LineSeries {
                                    id:tubeCOTLine
                                    XYPoint { x: 1; y: 840 }
                                    XYPoint { x: 2; y: 835 }
                                    XYPoint { x: 3; y: 844 }
                                    XYPoint { x: 4; y: 850 }
                                    XYPoint { x: 5; y: 847 }
                                    XYPoint { x: 6; y: 840 }
                                    XYPoint { x: 7; y: 833 }
                                    XYPoint { x: 8; y: 840 }
                                    XYPoint { x: 9; y: 847 }
                                    XYPoint { x: 10; y: 844 }
                                    XYPoint { x: 11; y: 850 }
                                    XYPoint { x: 12; y: 840 }
                                }
                            }

                        }

                    }


                    //bar chart
                    Item{
                        width: chartlist.width
                        height: chartlist.height
                        ChartView{
                            width: chartlist.width
                            height: chartlist.height
                            anchors.centerIn: parent
                            antialiasing: true
                            id:barChart
                            ValueAxis {
                                id: barAxisY
                                min: 700
                                max: 1100
                                labelFormat: "%.0f"
                            }
                            BarSeries {
                                id: bars
                                axisX: BarCategoryAxis {
                                    categories: ["1", "2", "3", "4", "5", "6","7","8","9","10","11","12" ]
                                }
                                axisY: barAxisY
                                BarSet { label: "出管温度"; values: [966, 966,966, 966, 966, 966,966,966,966,966,966] }
                                BarSet { label: "入管温度"; values: [888,888,888,888,888,888,888,888,888,888,888,888] }
                                BarSet { label: "COT温度"; values: [855,855,855,855,855,855,855,855,855,855,855,855] }
                            }
                        }
                    }

                }
            }

            //group chooser
            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                y:15
                spacing: 50
                Repeater{
                    model: 4
                    delegate: Text{
                        font.pixelSize: 20
                        color: currentGroup === index?"#12eeff": "#666666"
                        text: "第"+Number(index+1)+"组"
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                currentGroup = index;
                            }
                        }
                        Rectangle{
                            anchors.top: parent.bottom
                            anchors.topMargin: 10
                            width: parent.width
                            height: 3
                            color: "#12eeff"
                            opacity: index === currentGroup?1:0
                            Behavior on opacity {
                                PropertyAnimation{
                                    properties: "opacity"
                                    duration: 100
                                }
                            }
                        }
                    }
                }
            }

            //bnts
            Column{
                anchors.right: parent.right
                anchors.rightMargin: 25
                y:25
                spacing: 10
                id:bntsCol
                RoundIconButton{
                    text: currentDisplayState === 0?"显示直方图":"显示线性图"
                    imgSrc: currentDisplayState === 0?"qrc:/imgs/icons/line.png": "qrc:/imgs/icons/straight.png"
                    onBngClicked: {
                        currentDisplayState = currentDisplayState === 0? 1:0
                    }

                    width: 120
                    height: 36
                }
                RoundIconButton{
                    text: "导入新数据"
                    imgSrc: "qrc:/imgs/icons/add.png"
                    width: 120
                    height: 36
                    onBngClicked: {

                    }
                }
            }
        }
    }

}
