import QtQuick 2.0
import "../bar"
import "../Widget"
import QtCharts 2.1
import QtQml.Models 2.2
import SerialPortManager 1.0
import QtQuick.Controls 1.4

Item {
    id:root
    anchors.fill: parent
    property int currentFornace : 0
    property int currentGroup: 0
    property int currentDisplayState:0
    property int currentPortIndex:0//串口索引值
    property bool readyReciveData:false//串口接收状态
    property var furnaces:[
        "H110","H111","H112","H113","H114","H115","H116","H117","H118","H119","H120"
    ]
    property var requestData;

    function refresh(){
        requestData = {};
        requestData.tubeInDatas = server.access_tube_in_temp();
        requestData.tubeOutDatas = server.access_tube_out_temp();
        requestData.tubeCOTDatas = server.access_tube_out_temp();
    }

    //串口数据导入排错检测
    function checkStr(str){
        //排错1
        //校检符号为,的个数，是否整齐，单段104个
        var seg1=String(str).match(new RegExp(",","g"));
        console.log("number is,",seg1.length);

        //校检符号位#的个数是否整齐，单端8个
        var seg2=String(str).match(new RegExp("#","g"));
        console.log("number is,",seg2.length);

        if((seg1.length%104!==0||seg2.length%8!==0)&&seg2.length>0&&seg1.length>0){
            return false;
        }

        //排错2
        var value=str.toString().split("??");


        /*删除换行符的数据，占两个字符*/
        for(var a=0;a<value.length;a++){
            if(value[a].length===2){
                value.splice(a,1);
            }
        }

        if(value.length%9===0&&value.length>0){
            return true;
        }
        else{
            return false;
        }
    }


    Component.onCompleted: {
        refresh();
        tubeInLine.clear();
        tubeOutLine.clear();
        tubeCOTLine.clear();

        var tubeInBarValues = [];
        var tubeOutBarValues = [];
        var tubeCOTBarValues = [];

        for(var i = 0; i< 12; i++){
            var tempIn = requestData.tubeInDatas[currentGroup*12 + i].temp;
            var tempOut = requestData.tubeOutDatas[currentGroup*12 + i].temp;
            var tempCot = tempOut - 120;
            tubeInLine.append((i+1), tempIn);
            tubeOutLine.append((i+1), tempOut);
            tubeCOTLine.append((i+1), tempCot);

            tubeInBarValues.push(tempIn);
            tubeOutBarValues.push(tempOut);
            tubeCOTBarValues.push(tempCot);
        }

        tubeInBarSet.values = tubeInBarValues;
        tubeOutBarSet.values = tubeOutBarValues;
        tubeCOTBarSet.values = tubeCOTBarValues;
    }

    onCurrentGroupChanged: {
        tubeInLine.clear();
        tubeOutLine.clear();
        tubeCOTLine.clear();

        var tubeInBarValues = [];
        var tubeOutBarValues = [];
        var tubeCOTBarValues = [];

        for(var i = 0; i< 12; i++){
            var tempIn = requestData.tubeInDatas[currentGroup*12 + i].temp;
            var tempOut = requestData.tubeOutDatas[currentGroup*12 + i].temp;
            var tempCot = tempOut - 120;
            tubeInLine.append((i+1), tempIn);
            tubeOutLine.append((i+1), tempOut);

            //test for cot using tube_out datas
            tubeCOTLine.append((i+1),tempCot);

            tubeInBarValues.push(tempIn);
            tubeOutBarValues.push(tempOut);

            //test for cot using tube_out datas
            tubeCOTBarValues.push(tempCot);
        }

        tubeInBarSet.values = tubeInBarValues;
        tubeOutBarSet.values = tubeOutBarValues;
        tubeCOTBarSet.values = tubeCOTBarValues;
    }

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

                                BarSet {
                                    id:tubeOutBarSet
                                    label: "出管温度";
//                                    values: [966, 966,966, 966, 966, 966,966,966,966,966,966]
                                }
                                BarSet {
                                    id: tubeInBarSet
                                    label: "入管温度";
//                                    values: [888,888,888,888,888,888,888,888,888,888,888,888]
                                }
                                BarSet {
                                    id: tubeCOTBarSet
                                    label: "COT温度";
//                                    values: [855,855,855,855,855,855,855,855,855,855,855,855]
                                }
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
                        dataImportDialog.open();
                    }
                }
            }
        }
    }


    //串口数据缓存触发
    Timer{
        id:completeTimer
        interval: 1000
        onTriggered: {
            var datas=serialPortManager.revDatas;
            serialPortManager.revDatas="";
            console.log("datas:\n",datas);
            var ok=checkStr(datas);
            //错误提示框
            if(!ok){
                serialPortManager.closeSerialPort();
                readyReciveData=false;
                errorDialog.open();
                return;
            }

            var value=datas.toString().split("??");


            /*删除换行符的数据，占两个字符*/
            for(var a=0;a<value.length;a++){
                if(value[a].length===2){
                    value.splice(a,1);
                }
            }


            var count=value.length/9;

            for(var index=0;index<count;index++){
                console.log("header:",value[9*index+0]);

                var date=value[9*index+0].substr(value[9*index+0].indexOf("<")+1,8);
                console.log("date:",date);
                /*年*/
                var year=String(date).substring(0,4);
                console.log("year:",year);
                /*月*/
                var month=String(date).substring(4,6);
                console.log("month",month);
                /*日*/
                var day=String(date).substring(6,8);
                console.log("day",day);

                /*转换*/
                date=year+"-"+month+"-"+day;
                console.log("Date",date);

                /*时间*/
                var time=String(value[9*index+0]).split("-")[1];
                console.log("time:",time);
                /*时*/
                var hours=String(time).split(":")[0];
                if(Number(hours)<10)
                    hours="0"+String(Number(hours));
                else
                    hours=String(Number(hours));

                /*分*/
                var minute=String(time).split(":")[1];
                if(Number(minute)<10)
                    minute="0"+String(Number(minute));
                else
                    minute=String(Number(minute));

                /*秒*/
                var second=String(time).split(":")[2];
                if(Number(second)<10)
                    second="0"+String(Number(second));
                else
                    second=String(Number(second));
                /*转换*/
                time=hours+":"+minute+":"+second;


                /*时间+日期*/
                var dateTime=date+" "+time;
                console.log("dateTime convertion:",dateTime);



                /*炉号*/
                var s=Number(String(value[9*index+0]).split("-")[2].charAt(2));
                console.log("炉号",s);


                for(var j=1;j<9;j++){
//                        console.log(j+"号窗口：",value[9*index+j]);
                    var w=Number(String(value[9*index+j]).split("#")[1].charAt(0));
                    console.log("窗口号",w);
                    var temp18s=String(value[9*index+j]).split(",")

                    //g=4;location=tube_in
                    var g=4;
                    var location="tube_in";

                    if(w===1){
                        g=4;
                        location="tube_in";
                    }
                    else if(w===2){
                        g=4;
                        location="tube_out";
                    }
                    else if(w===3){
                        g=3;
                        location="tube_out";
                    }
                    else if(w===4){
                        g=3;
                        location="tube_in";
                    }
                    else if(w===5){
                        g=2;
                        location="tube_in";
                    }
                    else if(w===6){
                        g=2;
                        location="tube_out";
                    }
                    else if(w===7){
                        g=1;
                        location="tube_out";
                    }
                    else if(w===8){
                        g=1;
                        location="tube_in";
                    }
                    //１，３，５，７号窗口是从左到右读入，２，４，６，８号窗口是从又到左读入
                    var rule=0;

                    if(w%2===0)
                        rule=1;

                    //切割的字符串为这个，第一个和最后一个是废的
//                    5#1,896,894,896,890,898,883,898,885,896,897,882,881,10694
                    for(var a=1;a<temp18s.length-1;a++){
                        //半段是否采用从右到左的数据插入方法
                        if(rule===1)
                            var tubenum=13-a+(g-1)*12;
                        else
                            var tubenum=a+(g-1)*12;

                        var temp=Number(temp18s[a]);
//                        console.log("temp:",temp18s[a],"   ",a);
                        server.pushDatas(String(tubenum),String(s),String(location),String(temp),String(dateTime));
                    }
//                    console.log("group:",g,"tubenum:",tubenum,"foruneNum:",s,"location:",location,"temp:",temp,"datetime:",dateTime);


//                    //数据测试正确
//                    console.log(w+"号窗口",
//                                temp18s[1],
//                                temp18s[2],
//                                temp18s[3],
//                                temp18s[4],
//                                temp18s[5],
//                                temp18s[6],
//                                temp18s[7],
//                                temp18s[8],
//                                temp18s[9],
//                                temp18s[10],
//                                temp18s[11],
//                                temp18s[12]
//                                );

                }
            }


            //关闭串口（必须）
            serialPortManager.closeSerialPort();
            readyReciveData=false;

            //调用反馈器
            serialPortManager.writeDates("Data_Receive_Success!");

            //关闭导入数据对话框
            dataImportDialog.close();

            //显示成功导入数据对话框
            var msgComponent = Qt.createComponent("qrc:/UI/Widgets/MessageDialog.qml");
            if (msgComponent.status === Component.Ready) {
                var msgDialog = msgComponent.createObject(root);
                msgDialog.errorStr="    数据导入成功！";
                msgDialog.open();
            }
            //刷新数据
            refreshNewestDatas();

        }
    }

    //反馈计时器
    Timer{
        id:responseTimer
        interval: 2000
        onTriggered: {
        }
    }

    //串口设置
    SerialPortManager{

        id:serialPortManager
        onReadingFinish: {
            completeTimer.start();
        }
    }

    //串口名称列表
    ListModel{
        id:portModel
        Component.onCompleted: {
            for(var i=0;i<serialPortManager.getSerialPortsNum();i++){
                var portname=String(serialPortManager.getSerialPortName(i));
                portModel.append({
                                     "portName":portname,
                                     "isSelected":false

                                 });
                setProperty(0,"isSelected",true);
            }
            currentPortNameDisplayText.text="当前选择的串口:"+portModel.get(currentPortIndex).portName;
        }
    }

    //data import dialog
    CustomDialog {
        id:dataImportDialog
        title: "无线数据导入"
        onRejected:{
            readyReciveData = false;
        }

        content: Rectangle {
            id:itemContent
            color: "#12ccef"
            implicitWidth: 500
            implicitHeight: 500

            Column{
                anchors.fill: parent
                Rectangle{
                    width: itemContent.width
                    height: 40
                    color:"#454545"
                    Flickable{
                        anchors.fill: parent
                        contentWidth: row2.width
                        Row{
                            id:row2
                            Repeater{
                                model: portModel
                                delegate: CheckButton{
                                    bntText: portName
                                    selected: isSelected
                                    onBntClicked: {
                                        currentPortIndex=index;
                                        console.log(portModel.get(index).portName)
                                        for(var i=0;i<portModel.count;i++){
                                            if(i===index)
                                                continue;
                                            if(portModel.get(i).isSelected){
                                                portModel.setProperty(i,"isSelected",false);
                                            }
                                        }
                                        portModel.setProperty(index,"isSelected",true);
                                        currentPortNameDisplayText.text="当前选择的串口:"+portModel.get(currentPortIndex).portName;
                                        //设置串口
                                        serialPortManager.setPortName(portName);
                                    }
                                }
                            }
                        }
                    }
                }
                Item{
                    width: itemContent.width
                    height: itemContent.height-100
                    Text{
                        id:currentPortNameDisplayText
                        anchors.horizontalCenter: parent.horizontalCenter
                        y:20
                        text:"当前选择的串口:"+portModel.get(currentPortIndex).portName
                        color:"#ffffff"
                        font.pointSize: 25
                    }
                    TextArea{
                        width: parent.width-60
                        height: 200
                        anchors.centerIn: parent
                        id:messageText
                        text:readyReciveData?"   正在接收数据中，请用遥控器发送数据到zigbee接收器"
                                            :
                                              "  请选择zigbee接收器串口对应的串口，然后再按下开始接收按钮，系统会自动接收遥控器发来的数据，直到接收完毕，如果没有找到串口号，请检擦zigbee接收器是否正常安装驱动。如果不知道哪个串口对应zigbee接收器的，可以先拔出usb线，然后点击导入数据按钮查看串口第一次，然后关闭对话框，重新插入usb线，再点击导入数据按钮查看串口第二次，如果第二次出现了第一次查看串口时没有的串口名，说明这就是对应zigbee接收器的串口！或者在系统中查看串口。"
                        font.pointSize: 20
                        backgroundVisible: false
                        readOnly: true
                        textColor: "#ffffff"
                    }
                }

                Item{
                    width:parent.width
                    height:60
                    Row{
                        anchors.centerIn: parent
                        spacing: 100
                        RoundIconButton{
                           text: readyReciveData?"取消接收":"开始接收数据"
                            onBngClicked: {
                                readyReciveData=readyReciveData?false:true
                                if(readyReciveData){
                                    var ok=serialPortManager.openSerialPort();
                                    if(!ok){
                                        //打开串口失败
                                        readyReciveData=false;
                                        serialPortManager.closeSerialPort();
                                        //串口打开错误对话框
                                        var msgComponent = Qt.createComponent("qrc:/UI/Widgets/MessageDialog.qml");
                                        if (msgComponent.status === Component.Ready) {
                                            var msgDialog = msgComponent.createObject(root);
                                            msgDialog.errorStr="    串口打开失败，可能有其他程序在占用此串口，请手动关闭其他占用该串口的程序，再重新打开串口。";
                                            msgDialog.open();
                                        }
                                    }
                                }
                                else{
                                    serialPortManager.closeSerialPort();
                                }
                            }
                        }
                    }
                }
            }


        }
    }


    CustomDialog{
        id:errorDialog
        title: "错误"
        content: Item{
            width: 500
            height: 400
            TextArea{
                anchors.fill: parent
                text:"由于接收的数据不完整导致数据导入失败，请重新打开串口接收数据，建议遥控存的数据不要超过三组，以提高数据接收完整度"
            }
        }
    }
}
