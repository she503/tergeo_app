import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import "CustomControl"

Rectangle {
    id: root

    color: "transparent"
    property bool has_error: false
    property Component user_manage_page: UserManagePage {}
    property Component help_document_page: HelpDocumentPage { }
    property Component about_machine_page: AboutMachinePage { }
    signal mainPageChanged(var current_index)


    //to do
    Connections {
        target: map_task_manager
        onUpdateMapAndTaskInfo: {
            stack_menu.replace(task_process_page)
            stack_view.replace(task_settings_page)

        }
    }
    Connections {
        target: map_task_manager
        onUpdateStopTaskInfo: {
            if (status === 1) {
                root.mainPageChanged(0)
                stack_menu.replace(list_view)
                list_view.currentIndex = 0
            }
        }
    }
    onMainPageChanged: {
        if (current_index === 0) {
            stack_view.replace(home_page)
        } else if (current_index === 1) {
            stack_view.replace(user_manage_page)
        } else if (current_index === 2) {
            task_settings_page.visible = true
            stack_view.replace(task_settings_page)
            map_task_manager.judgeIsMapTasks()
            map_task_manager.getFirstMap()
//            stack_menu.replace(task_process_page) // delet
        } else if (current_index === 3) {
            stack_view.replace(help_document_page)
        } else if (current_index === 4) {
            stack_view.replace(about_machine_page)
        }
        task_settings_page.checked_tasks_name = []
    }

    HomePage {
        id: home_page
        onProBarPress: {
            if ( map_task_manager.getIsWorking() ) {
                stack_menu.replace(task_process_page)
                root.mainPageChanged(2)
            } else {
                dialog_working_states.dia_title = qsTr("Error")
                dialog_working_states.dia_content = qsTr("There is no task is working, you can click the \"setting\" btn to create one!")
                dialog_working_states.open()
            }
        }
        onStartBtnPress: {
            if (!map_task_manager.getIsWorking()) {
                list_view.currentIndex = 2
                stack_menu.replace(list_view)
                root.mainPageChanged(2)
            } else {
                dialog_working_states.dia_title = qsTr("Faild")
                dialog_working_states.dia_content = qsTr("Faild turn to task page, the jiqi is working!")
                dialog_working_states.open()
            }
        }
    }
    TaskSettingsPage {
        id: task_settings_page
        visible: false
        width: rect_right.width
        height: rect_right.height

    }

    Image {
        id: img_main_background
        source: "qrc:/res/pictures/main_background.png"
        anchors.fill: parent
    }

    Rectangle {
        id: rect_title
        width: parent.width
        height: parent.height * 0.082
        color: "transparent"

        MessageViewPage {
            id: message_view
            height: parent.height * 0.8
            width: height * 3
            anchors {
                right: rect_title.right
                rightMargin: height * 0.6
                verticalCenter: parent.verticalCenter
            }
            onLockScreen: {
                message_view.is_locked = true
                if (pop_lock.open()) {
                    pop_lock.close()
                } else {
                    pop_lock.open()
                }
            }
        }
    }

    Popup {
        id: pop_lock
        width: parent.width
        height: parent.height
        modal: true
        focus: true
        dim: false
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        background: Rectangle {
            anchors.fill: parent
            opacity: 0.5
            RadialGradient {
                anchors.fill: parent
                gradient: Gradient
                {
                    GradientStop{position: 0.3; color:"grey"}
                    GradientStop{position: 1; color:"black"}
                }
            }
        }
        contentItem: Item {
            anchors.fill: parent
            Rectangle {
                anchors.centerIn: parent
                color: "transparent"
                height: parent.height * 0.1
                width: height
                Image {
                    anchors.fill: parent
                    source: "qrc:/res/pictures/password.png"
                    fillMode: Image.PreserveAspectFit
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        message_view.is_locked = false
                        dialog_unlock.open()
                    }
                }
            }
        }
    }
    Dialog {
        id: dialog_unlock
        width: root.width * 0.45
        height: root.height * 0.4
        x:(root.width - width) / 2
        y: (root.height - height) / 2
        background: Rectangle {
            anchors.fill: parent
            color: "transparent"
        }
        contentItem: Item {
            anchors.fill: parent
            Rectangle {
                id: rect_password_input
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                color: "transparent"
                Image {
                    anchors.fill: parent
                    source: "qrc:/res/pictures/background_glow2.png"
                }
                Rectangle {
                    color: "white"
                    anchors.centerIn: parent
                    width: parent.width * 0.8
                    height: parent.height * 0.75
                    Rectangle {
                        id: rect_unlock_title
                        width: parent.width
                        height: parent.height * 0.3
                        color: "transparent"
                        Text {
                            color: "red"
                            text: qsTr("Enter password to unlock")
                            font.pixelSize: parent.height * 0.4
                        }
                    }

                    Rectangle {
                        id: rect_pwd
                        width: parent.width * 0.95
                        height: parent.height * 0.25
                        color:"transparent"
                        anchors {
                            top: rect_unlock_title.bottom
                            topMargin: height * 0.4
                            horizontalCenter: parent.horizontalCenter
                        }

                        Label {
                            id: lab_pwd
                            width: parent.width * 0.3
                            height: parent.height
                            text: qsTr("PWD")
                            horizontalAlignment: Text.AlignRight
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: height * 0.4
                            anchors{
                                top: parent.top
                            }
                            color: "#006abe"
                        }
                        TLTextField {
                            id: password
                            width: parent.width * 0.55
                            height: parent.height * 0.8
                            text: qsTr("")
                            anchors {
                                left: lab_pwd.right
                                leftMargin: parent.width * 0.05
                                verticalCenter: parent.verticalCenter

                            }
                            btn_radius: height * 0.1
                            placeholderText: qsTr("enter your password.")
                            echoMode: TextInput.Password
                            pic_name: "qrc:/res/pictures/password.png"
                            validator: RegExpValidator{regExp:/^.[A-Za-z0-9]{0,16}$/}
                        }
                    }

                    TLButton {
                        id: btn_ok
                        width: parent.width * 0.3
                        height: parent.height * 0.2
                        btn_text: qsTr("unclock")
                        font_size: height * 0.5
                        anchors {
                            top: rect_pwd.bottom
                            topMargin: parent.height * 0.04

                            horizontalCenter: parent.horizontalCenter
                            horizontalCenterOffset: parent.width * 0.03

                        }
                        onClicked: {
                            if (password.text === login_page.current_login_password) {
                                message_unclock_faild.close()
                                dialog_unlock.close()
                                pop_lock.close()
                            } else {
                                dialog_unlock.close()
                                message_unclock_faild.open()
                            }
                        }
                    }
                }
            }
        }
    }
    TLDialog {
        id: message_unclock_faild
        width: root.width * 0.45
        height: root.height * 0.4
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        dia_title: qsTr("error!")
        status: 0
        cancel_text: qsTr("OK")
        dia_content: qsTr("Password input error, please re-enter!")
        onCancelClicked: {
            if (password.text === login_page.current_login_password) {
                message_unclock_faild.close()
                dialog_unlock.close()
                pop_lock.close()
            } else {
                message_unclock_faild.close()
                dialog_unlock.open()
            }
        }
    }

    Rectangle {
        id: rec_left
        anchors {
            top: rect_title.bottom
        }
        width: height * 0.5
        height: parent.height - rect_title.height
        color: "transparent"

        StackView {
            id: stack_menu
            anchors.fill: parent
            initialItem: list_view

            replaceEnter: Transition {

            }
            replaceExit: Transition {

            }
        }

        ListView {
            id: list_view
            //            anchors.fill: parent
            spacing: height * 0.002
            currentIndex: 0
            highlight: Rectangle {color: "transparent"}
            clip: true
            highlightFollowsCurrentItem: false
            delegate: ItemDelegate {
                id: item
                height: list_view.height / 5
                width: height * 2.5
                property real id_num: model.id_num
                Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    Image {
                        id: img_background
                        source: model.focus_source
                        opacity: list_view.currentIndex == item.id_num ? 1 : 0.3
                        anchors.fill: parent
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                    }
                }

                onClicked: {
                    list_view.currentIndex = index
                    mainPageChanged(list_view.currentIndex)
                }
            }
            model: ListModel {
                ListElement {
                    id_num: 0
                    focus_source: "qrc:/res/pictures/home.png"
                }
                ListElement {
                    id_num: 1
                    focus_source: "qrc:/res/pictures/user.png"
                }
                ListElement {
                    id_num: 2
                    focus_source: "qrc:/res/pictures/task.png"
                }
                ListElement {
                    id_num: 3
                    focus_source: "qrc:/res/pictures/help.png"
                }
                ListElement {
                    id_num: 4
                    focus_source: "qrc:/res/pictures/about.png"
                }
            }
        }

        TaskProcess{
            id:task_process_page
            visible: false
            onSigBackBtnPress: {
                list_view.currentIndex = 0
                stack_menu.replace(list_view)
                stack_view.replace(home_page)
            }

            onSigStopBtnPress: {

            }

            onSigEndingBtnPress: {

            }
        }
    }

    Rectangle {
        id: rect_right
        width: parent.width - rec_left.width
        height: parent.height - rect_title.height
        color:"transparent"
        anchors{
            top: rect_title.bottom
            left: rec_left.right
        }
        StackView {
            id: stack_view
            anchors.fill: parent
            initialItem: home_page

            replaceEnter: Transition {

            }
            replaceExit: Transition {

            }
        }
    }


    TLDialog {
        id: dialog_working_states

    }

    //    TLDialog {
    //        id: dialog_machine_back
    //        width: root.width * 0.4
    //        height: root.height * 0.4
    //        x: (root.width - width) / 2
    //        y: (root.height - height) / 2
    //        dia_title: qsTr("Back!")
    //        dia_title_color: "#4F94CD"
    //        dia_image_source: "qrc:/res/pictures/smile.png"
    //        onOkClicked: {
    //            dialog_machine_back.close()
    //        }
    //    }
}
