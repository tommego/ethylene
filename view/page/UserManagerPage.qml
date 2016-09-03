import QtQuick 2.0
import "../Widget"
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Item {
    id:root
    anchors.fill: parent

    ListModel{
        id: userModel
        Component.onCompleted: {
            for(var a = 0; a<20; a++)
                append({
                           "userName":"user"+Number(a).toString(),
                           "userPwd":"asdfdf",
                           "userAccess":0,
                           "userNameEditting":false,
                           "userPwdEditting":false
                       });
        }
    }

    Column{
        anchors.fill: parent

        //header
        Item{
            width: parent.width-20
            height: 50
            id: header
            anchors.horizontalCenter: parent.horizontalCenter

            //header
            Row{
                anchors.fill: parent
                Rectangle{
                    width: parent.width/3
                    height: parent.height
                    color: "#344750"

                    RoundIconButton{
                        anchors.centerIn: parent
                        textSize: 20
                        text: "用户"
                        imgSrc: "qrc:/imgs/icons/icon_user.png"
                        height: 50
                        enabled: false
                    }

                    Image {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.rightMargin: 25
                        source: bntUserAdd.containsMouse?"qrc:/imgs/icons/button_user_add_hover.png":"qrc:/imgs/icons/button_user_add_normal.png"
                        MouseArea{
                            anchors.fill: parent
                            id:bntUserAdd
                            hoverEnabled: true
                        }
                    }

                }

                Rectangle{
                    width: parent.width/3
                    height: parent.height
                    color: "#344750"

                    RoundIconButton{
                        anchors.centerIn: parent
                        textSize: 20
                        text: "密码"
                        imgSrc: "qrc:/imgs/icons/icon_user_pwd-password-.png"
                        height: 50
                        enabled: false
                    }
                    Rectangle{
                        width: 1
                        height: parent.height
                    }
                }

                Rectangle{
                    width: parent.width/3
                    height: parent.height
                    color: "#344750"
                    RoundIconButton{
                        anchors.centerIn: parent
                        textSize: 20
                        text: "操作权限"
                        imgSrc: "qrc:/imgs/icons/icon_user_access.png"
                        height: 50
                        enabled: false
                    }
                    Rectangle{
                        width: 1
                        height: parent.height
                    }
                }

            }
        }

        //
        Rectangle{
            width: parent.width - 20
            height: parent.height - header.height
            border.width: 1
            border.color: "#aaaaaa"
            anchors.horizontalCenter: parent.horizontalCenter
            Flickable{
                id:contnetFlic
                width: parent.width - 2
                height: parent.height - 2
                anchors.centerIn: parent
                clip: true
                contentHeight: gridContent.height
                contentWidth: gridContent.width
                anchors.horizontalCenter: parent.horizontalCenter
                boundsBehavior: Flickable.DragOverBounds
                flickableDirection: Qt.Vertical

                Item{
                    id:gridContent
                    height: gridCol.height
                    width: root.width - 20

                    Column{
                        id:gridCol
                        width: parent.width

                        Repeater{
                            model:userModel
                            delegate: Rectangle{
                                width: gridContent.width
                                height: 40
                                color: index%2 === 0? "#eef4f7":"white"

                                Row{
                                    anchors.fill: parent

                                    //user name
                                    Item{
                                        width: parent.width/3
                                        height: parent.height
                                        id:userNameItem

                                        Row{
                                            anchors.centerIn: parent
                                            spacing: 10
                                            TextField{
                                                id:userNameTextEditor
                                                text: userName
                                                font.pixelSize: 16
                                                width: userNameItem.width/2
                                                height: 30
                                                textColor:activeFocus?"#12aadf":"454545"
                                                enabled: userNameEditting

                                                style: TextFieldStyle{
                                                    background: Rectangle{
                                                        width: control.width
                                                        height: control.height
                                                        color: "#00000000"
                                                        Rectangle{
                                                            width: parent.width
                                                            height: 1
                                                            anchors.bottom: parent.bottom
                                                            color: "#12aaef"
                                                            visible: control.activeFocus
                                                        }
                                                    }
                                                }
                                            }

                                            //user password
                                            Image {
                                                source: "qrc:/imgs/icons/modify.png"
                                                anchors.verticalCenter: parent.verticalCenter
                                                MouseArea{
                                                    anchors.fill: parent
                                                    onClicked: {
                                                        for(var a = 0; a<userModel.count;a ++){
                                                            if(a === index)
                                                                continue;
                                                            userModel.setProperty(a,"userPwdEditting",false);
                                                            userModel.setProperty(a,"userNameEditting",false);
                                                        }


                                                        if(userNameEditting){
                                                            userModel.setProperty(index,"userNameEditting",false);
                                                            root.forceActiveFocus();
//                                                            userNameTextEditor.enabled = false;
                                                        }
                                                        else{
                                                            userModel.setProperty(index,"userNameEditting",true);
//                                                            userNameTextEditor.enabled = true;
                                                            userNameTextEditor.forceActiveFocus();
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    //user password
                                    Item{
                                        width: parent.width/3
                                        height: parent.height
                                        id:userPwdItem

                                        Row{
                                            anchors.centerIn: parent
                                            spacing: 10
                                            TextField{
                                                id:userPwdTextEditor
                                                text: userPwd
                                                font.pixelSize: 16
                                                width: userPwdItem.width/2
                                                height: 30
                                                enabled: userPwdEditting
                                                textColor:activeFocus?"#12aadf":"454545"

                                                style: TextFieldStyle{
                                                    background: Rectangle{
                                                        width: control.width
                                                        height: control.height
                                                        color: "#00000000"
//
                                                        Rectangle{
                                                            width: parent.width
                                                            height: 1
                                                            anchors.bottom: parent.bottom
                                                            color: "#12aaef"
                                                            visible: control.activeFocus
                                                        }
                                                    }
                                                }
                                            }

                                            Image {
                                                source: "qrc:/imgs/icons/modify.png"
                                                anchors.verticalCenter: parent.verticalCenter
                                                MouseArea{
                                                    anchors.fill: parent
                                                    onClicked: {
                                                        for(var a = 0; a<userModel.count;a ++){
                                                            if(a === index)
                                                                continue;
                                                            userModel.setProperty(a,"userPwdEditting",false);
                                                            userModel.setProperty(a,"userNameEditting",false);
                                                        }


                                                        if(userPwdEditting){
                                                            userModel.setProperty(index,"userPwdEditting",false);
                                                            root.forceActiveFocus();
                                                        }
                                                        else{
                                                            userModel.setProperty(index,"userPwdEditting",true);
                                                            userPwdTextEditor.forceActiveFocus();
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }

                                    Item{
                                        width: parent.width/3
                                        height: parent.height
                                        id:userAccessItem

                                        CustomComboBox{
                                            anchors.right: parent.right
                                            anchors.rightMargin: 20
                                            anchors.centerIn: parent
                                            model: ["普通","管理员"]
                                            currentIndex: userAccess
                                            onCurrentIndexChanged: {
                                                userModel.setProperty(index,"userAccess",currentIndex);
                                            }

                                        }

                                        Rectangle{
                                            anchors.centerIn: iconUserDelete
                                            radius: 2
                                            color: "#ff9912"
                                            width: 30
                                            height: 30
                                            scale: iconUserDelete.scale
                                            MouseArea{
                                                anchors.fill: parent
                                                id:bntUserDelete
                                                hoverEnabled: true
                                                onClicked: {
                                                    userModel.remove(index)
                                                }
                                            }
                                        }

                                        Image {
                                            id:iconUserDelete
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.rightMargin: 20
                                            scale: bntUserDelete.containsMouse?1.1:1
                                            source: "qrc:/imgs/icons/button_delete.png"
                                            width: 15
                                            height: 15
                                            Behavior on scale{
                                                PropertyAnimation{
                                                    properties: "scale"
                                                    duration: 200
                                                    easing.type: Easing.OutBack
                                                }
                                            }
                                        }

                                    }


                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
