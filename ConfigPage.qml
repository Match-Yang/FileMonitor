import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
Page {
    header: Frame {
        height: 60
        background: Rectangle {
            color: "#1258a8"
        }

        Label {
            anchors.centerIn: parent
            text: qsTr("File Monitor")
        }
    }
    contentItem: Frame {
        padding: 0
        background: Rectangle {
            color: "#1565c0"
        }
        Rectangle {
            id: watch_dir_frame
            width: parent.width
            height: 300
            color: "#135db0"
            Column {
                anchors.fill: parent
                spacing: 10
                OpenPathItem {
                    width: parent.width
                    height: 50
                    source: "qrc:/images/images/baseline_last_page_white_18dp.png"
                    placeholderText: qsTr("Select A Shell program")
                    text: "/bin/bash"
                    ToolTip.visible: hovered
                    ToolTip.delay: 500
                    ToolTip.text: qsTr("Take effect on next run")
                }
                OpenPathItem {
                    width: parent.width
                    height: 50
                    source: "qrc:/images/images/baseline_folder_open_white_18dp.png"
                    placeholderText: qsTr("Select Target Dir To Watching")
                }
                OpenPathItem {
                    width: parent.width
                    height: 50
                    source: "qrc:/images/images/baseline_apps_white_18dp.png"
                    placeholderText: qsTr("Select A Script To Receive File Change")
                }
            }
        }

        CmdOptionListField {
            width: parent.width
            height: parent.height / 5 * 3
            anchors.top: watch_dir_frame.bottom
        }
    }
}
