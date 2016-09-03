import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import "../Widget"
import QtCharts 2.1
import QtQuick.Dialogs 1.2
import QtGraphicalEffects 1.0
Item {
    id:root
    anchors.fill: parent
    property date fromDate: new Date("2016-01-01 00:00:00")
    property date toDate:new Date("2016-01-20 00:00:00")

    property string borderColor:"#dadada"
    property string bgColor: "#f6f6f6"
    property int borderWidth:1
    property string fontColorNormal: '#333333'
    property string fontColorTip: "#999999"

//    property bool showTubeInCompareLines: showTubeInOptionSwitch.checked
//    property bool showTubeOutCompareLines: showTubeOutOptionSwitch.checked
//    property bool showTubeCOTCompareLines: showTubeCOTOptionSwitch.checked

    property var tubeInLineStyle: Qt.SolidLine
    property var tubeOutLIneStyle: Qt.DashLine
    property var tubeCOTLineStyle: Qt.DashDotDotLine

    property var tubeInResultLines:[]
    property var tubeOutResultLines:[]
    property var tubeCOTResultLines: []

    property int currentEdittingTube:0

    property var colorSet:[
        "#FF0000","#FF1493","#104E8B","#080808","#00688B","#00CED1","#3A5FCD","#404040",
        "#32CD32","#27408B","#4B0082","#6B8E23","#8B0A50","#8968CD","#708090","#7A67EE",
        "#636363","#548B54","#8B6508","#CD2990","#B9D3EE","#8B8378","#8B5A2B","#8470FF",
        "#4A4A4A","#141414","#171717","#4A708B","#54FF9F","#555555","#7A378B","#8B1A1A",
        "#636363","#548B54","#8B6508","#CD2990","#B9D3EE","#8B8378","#8B5A2B","#8470FF",
        "#32CD32","#27408B","#4B0082","#6B8E23","#8B0A50","#8968CD","#708090","#7A67EE",
    ]
//    Component.onCompleted: {

//        for(var a = 0; a<selectedTubeListModel.count; a++){

//            var myAxisX = chartView.axisX(lineSeries);
//            var myAxisY = chartView.axisY(lineSeries);
//            var lineIn = chartView.createSeries(ChartView.SeriesTypeLine, "T"+selectedTubeListModel.get(a).tubeNum, myAxisX, myAxisY);
//            var lineOut = chartView.createSeries(ChartView.SeriesTypeLine, "T"+selectedTubeListModel.get(a).tubeNum, myAxisX, myAxisY);
//            var lineCOT = chartView.createSeries(ChartView.SeriesTypeLine, "T"+selectedTubeListModel.get(a).tubeNum, myAxisX, myAxisY);

//            var mdatas = [];
//            for(var b = 0; b<20; b++){
//                var mdata = {};
//                mdata.tubeInTemp = 860 + Math.random()*20;
//                mdata.tubeOutTemp = 920 + Math.random()*20;
//                mdata.tubeCOTTemp = 820 + Math.random()*20;

//                var day = (b+1)>10? Number(b+1).toString():"0"+Number(b+1).toString();

//                mdata.time = new Date("2016-01-"+day+" 00:00:00");
//                mdata.lineColor = selectedTubeListModel.get(a).displayColor;
//                mdatas.push(mdata);

//                //add spot
//                lineIn.append(mdata.time,mdata.tubeInTemp);
//                lineOut.append(mdata.time,mdata.tubeOutTemp);
//                lineCOT.append(mdata.time,mdata.tubeCOTTemp);

//                //set line color
//                lineIn.color = selectedTubeListModel.get(a).displayColor;
//                lineOut.color = selectedTubeListModel.get(a).displayColor;
//                lineCOT.color = selectedTubeListModel.get(a).displayColor;

//                //set line style
//                lineOut.style = tubeInLineStyle;
//                lineCOT.style = tubeOutLIneStyle;
//                lineIn.style = tubeCOTLineStyle;
//            }
//            //restore lines to further control
//            tubeInResultLines.push(lineIn);
//            tubeOutResultLines.push(lineOut);
//            tubeCOTResultLines.push(lineCOT);

//        }
////        xAxis.tickCount = tubeInResultLines[0].count>15?15:tubeInResultLines[0].count
//    }

    //selected tube list model
    ListModel{
        id:selectedTubeListModel
    }

    ListModel{
        id:tubeListModel
        Component.onCompleted: {
            for(var a = 0; a<48; a++){
                append({
                           "tubeNum":Number(a+1),
                           "selected":false,
                           "displayColor":colorSet[a]
                       });
            }
        }
    }

    Rectangle{
        id:bg
        anchors.fill: parent
        color: bgColor
    }

    Row{
        id:mainRow
        width: parent.width-40
        height: parent.height-40
        anchors.centerIn: parent
        spacing: 20
        //left bar
        Rectangle{
            id:leftBar
            width: 200
            height: parent.height
            radius: 2
            border.width: borderWidth
            border.color: borderColor

            Column{
                anchors.fill: parent
                //title
                Item{
                    id:title
                    width: parent.width
                    height: 40
                    MouseArea{
                        anchors.fill: parent
                        onClicked: tubeSelectorDialog.open()
                    }
                    Row{
                        anchors.centerIn: parent
                        spacing: 20
                        Item{
                            width: titleText.width
                            height: 20
                            Text{
                                id:titleText
                                text: "比较炉管列表"
                                font.pixelSize: 18
                                color: fontColorNormal
                                anchors.centerIn: parent
                            }
                        }

                        Image {
                            id: addBnt
                            source: "qrc:/imgs/icons/add1.png"
                        }

                    }

                    Rectangle{
                        id:line
                        width: parent.width-20
                        height: 1
                        color: borderColor
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                    }
                }

                //tube list content
                ListView{
                    id:tubeListConteent
                    clip: true
                    width: parent.width
                    height: parent.height - title.height-deleteBar.height
                    model:selectedTubeListModel
                    delegate: Item{
                        width: tubeListConteent.width
                        height: 50

                        Row{
                            anchors.centerIn: parent
                            spacing: 30
                            Rectangle{
                                width: 60
                                height: 20
                                color: "#f0f0f0"
                                Rectangle{
                                    width: 20
                                    height: parent.height
                                    color: displayColor
                                }
                                Text{
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    anchors.rightMargin: 15
                                    text: tubeNum
                                    font.pixelSize: 16
                                    color: fontColorNormal
                                }
                            }

                            Switch{
                                width: 50
                                height: 20
                                checked: selected

                                onCheckedChanged: {

                                    if(showTubeInCompareLines)
                                        tubeInResultLines[index].visible = checked;

                                    if(showTubeOutCompareLines)
                                        tubeOutResultLines[index].visible = checked;

                                    if(showTubeCOTCompareLines)
                                        tubeCOTResultLines[index].visible = checked;
//                                        tubeCOTResultLines[index].visible = checked;

                                }

                                style:SwitchStyle{
                                    groove: Rectangle {
                                            implicitWidth: control.width
                                            implicitHeight: control.height
                                            radius: height/2
                                            color: control.checked ? "#12eeff" : "#c0c0c0"
                                    }
                                    handle: Item{
                                        width: height + height/3
                                        height: control.height
                                        Rectangle{
                                            anchors.centerIn: parent
                                            width: parent.width-6
                                            height: parent.height-6
                                            radius: width/2
                                        }
                                    }
                                }

                            }
                        }
                    }
                }

                //delete bar
                Item{
                    id:deleteBar
                    height: 40
                    width: parent.width
                    Rectangle{
                        width: parent.width
                        height: 1
                        color: borderColor
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: selectedTubeListModel.clear();
                    }

                    Row{
                        anchors.centerIn: parent
                        spacing: 20
                        Item{
                            width: titleText.width
                            height: 20
                            Text{
                                text: "清空列表"
                                font.pixelSize: 18
                                color: fontColorNormal
                                anchors.centerIn: parent
                            }
                        }

                        Image {
                            id: deleteBnt
                            source: "qrc:/imgs/icons/delete.png"
                        }

                    }

                }
            }
        }

        //right content
        Item{
            width: parent.width-leftBar.width-20
            height: parent.height

            Column{
                anchors.fill: parent
                z:2
                spacing: 10
                //top bar
                Rectangle{
                    width: parent.width
                    height: 50
                    id: rightTopBar
                    border.width: 1
                    border.color: borderColor

                    // select row
                    Row{
                        anchors.centerIn: parent
                        spacing: 30
                        //from date picker
                        DatePicker{
                            id:fromDatPicker
                            anchors.verticalCenter: analisisBnt.verticalCenter
                        }

                        //text
                        Item{
                            width: 20
                            height: 20
                            anchors.verticalCenter: analisisBnt.verticalCenter
                            Text{
                                anchors.centerIn: parent
                                text: "到"
                                font.pixelSize: 18
                                color: "#12eeaa"
                            }
                        }

                        //to date picker
                        DatePicker{
                            id:toDatPicker
                            anchors.verticalCenter: analisisBnt.verticalCenter
                        }

                        //text
                        Item{
                            width: 20
                            height: 20
                            anchors.verticalCenter: analisisBnt.verticalCenter
                            Text{
                                anchors.centerIn: parent
                                text: "炉号"
                                font.pixelSize: 18
                                color: "#12eeaa"
                            }
                        }

                        //foruance num selector
                        ForanceNumComboBox{
                            id:foranceComboBox
                        }

                        //compare button
                        RoundIconButton{
                            text: "开始分析"
                            width: 120
                            height: 35
                            imgSrc: "qrc:/imgs/icons/bnt_comparer.png"
                            bgColor: "#12ccef"
                            id:analisisBnt
                        }

                        RoundIconButton{
                            imgSrc: "qrc:/imgs/icons/picture.png"
                            width: 120
                            height: 35
                            text: "导出图片"
                            bgColor: "#ff7700"
                            onBngClicked: {
                                saveImageDialog.open();
                            }
                        }
                    }

                }

                Item{
                    id:chartsItem
                    width: parent.width
                    height: parent.height - rightTopBar.height - 10

                    ScrollView{
                        anchors.fill: parent

                        //Analysis
                        Item{
                            width: chartsItem.width-80
                            x:40
                            height: chartsCol.height

                            Glow{
                                anchors.fill: chartsCol
                                color: "#10000000"
                                spread: 0.1
                                radius: 5
                                source: chartsCol
                                transparentBorder: true
                                fast: true
                                cached: true
                                samples: 15

                            }

                            Column{
                                width: parent.width
                                id:chartsCol
                                spacing: 20

                                ChartView{
                                    id:analysisChartView
                                    width: parent.width
                                    height: 300
                                    title: "入管温度／COT温度         ５号炉"
                                    titleColor: fontColorNormal
                                    titleFont.pixelSize: 20
                                }

                                ChartView{
                                    id:tubeChartView
                                    width: parent.width
                                    height: 600
                                    title: "温度趋势 ５号炉"
                                    titleFont.pixelSize: 20
                                    titleColor: fontColorNormal
                                }

                                ChartView{
                                    id:pressureChartView
                                    width: parent.width
                                    height: 300
                                    title: "压力趋势 ５号炉"
                                    titleFont.pixelSize: 20
                                    titleColor: fontColorNormal
                                }
                            }
                        }
                    }
                }



            }
        }
    }

    //dilaog
    CustomDialog{
        id: tubeSelectorDialog
        title: "管列表筛选框"
        content: Item{
            width: 500
            height: 500
            ListView{
                anchors.fill: parent
                id:tubeChosserListView
                model: tubeListModel
                clip: true
                delegate: Item{
                    width: tubeChosserListView.width
                    height: 80

                    Row{
                        anchors.centerIn: parent
                        spacing: 30
                        RadioButton{
                            checked: selected
                            onCheckedChanged: tubeListModel.setProperty(index,"selected",checked);
                            anchors.verticalCenter: parent.verticalCenter

                        }

                        Text{
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 16
                            text: Number(index+1)+"号管"
                        }

                        Rectangle{
                            width: 200
                            height: 5
                            color: displayColor
                            anchors.verticalCenter: parent.verticalCenter
                            border.width: 1
                            border.color: "#cfcfcf"
                        }

                        Image {
                            source: "qrc:/imgs/icons/modify.png"
                            anchors.verticalCenter: parent.verticalCenter
                            MouseArea{
                                anchors.fill: parent
                                onClicked: {
                                    currentEdittingTube = index;
                                    colorDialog.open();
                                }
                            }
                        }
                    }

                    Rectangle{
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width-100
                        height: 1
                        color: borderColor
                        opacity: 0.5
                    }
                }
            }
        }
        onAccepted: {
            selectedTubeListModel.clear();

            for(var a = 0; a<tubeListModel.count; a++){
                if(tubeListModel.get(a).selected){
                    selectedTubeListModel.append({
                                                     "tubeNum":tubeListModel.get(a).tubeNum,
                                                     "displayColor":tubeListModel.get(a).displayColor,
                                                     "selected":true
                                                 });
                }
            }
        }
    }

    ColorDialog{
        id:colorDialog

        onAccepted: {
            tubeListModel.setProperty(root.currentEdittingTube,"displayColor",color.toString());
        }
    }

    FileDialog{
        id:saveImageDialog
        onAccepted: {
            chartView.grabToImage(function(result){
                result.saveToFile(fileUrl);
            });
        }
    }

}
