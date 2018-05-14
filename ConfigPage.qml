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
            id: open_path_frame
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
                    text: configManager.value("Shell", "Path", "")
                    Component.onCompleted: {
                        if (configManager.value("Shell", "Path", "") == "") {
                            configManager.setValue("Shell", "Path", "/bin/bash")
                            text = "/bin/bash"
                        }
                    }
                }
                OpenPathItem {
                    width: parent.width
                    height: 50
                    source: "qrc:/images/images/baseline_folder_open_white_18dp.png"
                    placeholderText: qsTr("Select Target Dir To Watching")
                    text: configManager.value("FileWatcher", "Path", "")
                    onTextChanged: {
                        if (text !== configManager.value("FileWatcher", "Path")) {
                            fileWatcher.watchDir(text)
                        }
                    }
                }
                OpenPathItem {
                    width: parent.width
                    height: 50
                    source: "qrc:/images/images/baseline_apps_white_18dp.png"
                    placeholderText: qsTr("Select A Script To Receive File Change")
                    text: configManager.value("Script", "Path", "")
                    onTextChanged: {
                        configManager.setValue("Script", "Path", text)
                    }
                    Connections {
                        target: fileWatcher
                        onFileAdded: {
                            console.log(path)
                        }
                    }
                }
            }
        }

        CmdOptionListField {
            width: parent.width
            height: parent.height / 5 * 3
            anchors.bottom: parent.bottom
        }
    }

    Component.onCompleted: console.log(configManager.fileName())
}
