import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import Qt.labs.platform 1.0

Page {
    function urlToPath(url) {
        var path = url.toString();
        // remove prefixed "file://"
        path = path.replace(/^(file:\/{2})/,"");
        return path;
    }

    header: Rectangle {
        height: 60
//        background: Rectangle {
            color: "#1258a8"
//        }

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
                    id: target_item
                    width: parent.width
                    height: 50
                    source: "qrc:/images/images/baseline_folder_open_white_18dp.png"
                    placeholderText: qsTr("Select Target Dir To Watching")
                    onTextChanged: {
                        if (text !== configManager.value("FileWatcher", "Path")) {
                            fileWatcher.watchDir(text)
                            configManager.setValue("FileWatcher", "Path", text)
                        }
                    }
                    onClicked: {
                        target_dir_dlg.open()
                    }
                    Component.onCompleted: {
                        text = configManager.value("FileWatcher", "Path", "")
                    }

                    FolderDialog {
                        id: target_dir_dlg
                        title: qsTr("Select Traget Dir")
                        folder: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
                        onAccepted: {
                            target_item.text = urlToPath(target_dir_dlg.folder)
                        }
                    }
                }
                OpenPathItem {
                    id: script_item
                    width: parent.width
                    height: 50
                    source: "qrc:/images/images/baseline_apps_white_18dp.png"
                    placeholderText: qsTr("Select A Script To Receive File Change")
                    onTextChanged: {
                        if (text !== configManager.value("Script", "Path")) {
                            configManager.setValue("Script", "Path", text)
                        }
                    }
                    onClicked: script_dlg.open()
                    Connections {
                        target: fileWatcher
                        onFileAdded: {
                            ptyManager.setMessage(script_item.text + " " + path)
                        }
                    }
                    Component.onCompleted: {
                        script_item.text = configManager.value("Script", "Path", "")
                    }

                    FileDialog {
                        id: script_dlg
                        title: qsTr("Select the script that will be trigger after file add on target dir")
                        fileMode: FileDialog.OpenFile
                        folder: StandardPaths.writableLocation(StandardPaths.HomeLocation)
                        onAccepted: {
                            script_item.text = urlToPath(file)
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
