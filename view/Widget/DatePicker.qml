import QtQuick 2.0

Item {
    id:datepicker
    width: mainRow.width
    height: 20
    property int year:yearPlainText.text
    property int month:monthPlainText.text
    property int day: dayPlainText.text
    Row{
        id:mainRow
        spacing: 5
        PlainTextEdit{
            id: yearPlainText
            minNumber: 2000
        }
        Item{
            width: 20
            height: 20
            Text{
                text:"年"
                font.pixelSize: 16
                anchors.centerIn: parent
                color: "#333333"
            }
        }

        PlainTextEdit{
            maxNumber: 12
            minNumber: 1
            id: monthPlainText
        }
        Item{
            width: 20
            height: 20
            Text{
                text:"月"
                font.pixelSize: 16
                anchors.centerIn: parent
                color: "#333333"
            }
        }

        PlainTextEdit{
            maxNumber: 31
            minNumber: 1
            id: dayPlainText
        }
        Item{
            width: 20
            height: 20
            Text{
                text:"日"
                font.pixelSize: 16
                anchors.centerIn: parent
                color: "#333333"
            }
        }
    }

}
