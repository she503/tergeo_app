import QtQuick 2.0
import QtQuick.Controls 2.2
Rectangle {
    id: root
    width: parent.width
    height: parent.height * 0.1
    color: "transparent"
    signal sigBackBtnPress()
    signal sigWorkDown()

    Row {
        property real btn_spacing: parent.width * 0.03
        spacing: btn_spacing / 6
        height: parent.height
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        Image {
            id: btn_back
            source: "qrc:/res/ui/task/home.png"
            width: (parent.width -  parent.btn_spacing)/ 4
            height: parent.height
            fillMode: Image.PreserveAspectFit
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.sigBackBtnPress()
                }
            }
        }
        Image {
            id: btn_stop
            width: (parent.width -  parent.btn_spacing)/ 4
            height: parent.height
            source: _is_pause ? "qrc:/res/ui/task/btn_start.png" :
                                "qrc:/res/ui/task/btn_pause.png"
            fillMode: Image.PreserveAspectFit
            property bool _is_pause: false
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    map_task_manager.setPauseTaskCommond(!btn_stop._is_pause)
                }
            }
            Connections {
                target: map_task_manager
                onEmitPauseTaskRst: {
                    if (status === 0 ) {

                    } else if (status === 1 ) {
                        btn_stop._is_pause = !is_pause
                    }
                }
            }
        }
        Image {
            id: btn_ending
            width:  (parent.width -  parent.btn_spacing)/ 4
            height: parent.height
            source: "qrc:/res/ui/task/btn_stop_task.png"
            fillMode: Image.PreserveAspectFit
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.sigWorkDown()
                }
            }
        }

        Rectangle {
            width: btn_ending.paintedWidth - 4// (parent.width -  parent.btn_spacing)/ 4
            height: width
            color: "#4169E1"
            radius: height
            border.color: "#D3D3D3"
            border.width: 2
            anchors.verticalCenter: parent.verticalCenter
            Image {
                id: btn_clean_work
                width: parent.height * 0.8
                height: parent.height* 0.8
                anchors.centerIn: parent
                source: "qrc:/res/pictures/clean_on.png"

                fillMode: Image.PreserveAspectFit
                property bool clean_work: true
                property bool is_first_init: true

            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    map_task_manager.setEnableCleanWork(!btn_clean_work.clean_work)
                }
            }
//            Connections{
//                target: socket_manager
//                onEmitEnableCleanWorkRst: {
//                    btn_clean_work.clean_work = flag
//                    btn_clean_work.source = btn_clean_work.clean_work ? "qrc:/res/pictures/clean_on.png":
//                                                                        "qrc:/res/pictures/clean_off.png"
//                }
//            }
            Connections {
                target: ros_message_manager
                onUpdateChassisInfo: {

                        btn_clean_work.source = cleaning_agency_state == 1 ? "qrc:/res/pictures/clean_on.png":
                                                                             "qrc:/res/pictures/clean_off.png"
                }
            }

        }
    }
}
