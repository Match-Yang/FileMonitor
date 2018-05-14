import QtQuick 2.9
import QtQuick.Controls 2.2
import Qt.labs.platform 1.0

Rectangle {
    color: "#1461b8"

    readonly property string _config_group: "FilterPair"

    MessageDialog {
        id: warning_dlg
        buttons: MessageDialog.Ok
        detailedText: "当监视的目录发生改变时，会传递当前时间为最新的文件路径作为指定脚本的输入！
    千万不要在脚本中做：
sudo rm -rf *
此类潇洒的操作。
此程序只为调试方便使用！
离开电脑前务必锁屏或者清除填充的密码，否则，其他人可以对你系统进行各种YY！！！"
        informativeText: "请务必注意自动填充(比如自动填充密码)的利弊"
        text: "免责声明"
        title: "Warning"
        modality: Qt.ApplicationModal
    }

    CheckBox {
        id: enable_box
        text: qsTr("Enable Auto Fill")
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 15
        checked: configManager.value(_config_group, "EnableFilter", true)
        onCheckedChanged: {
            if (checked)
                warning_dlg.open()

            configManager.setValue(_config_group, "EnableFilter", checked)
        }
    }

    Column {
        enabled: enable_box.checked
        anchors.top: enable_box.bottom
        width: parent.width
        height: parent.height - enable_box.height - apply_option_btn.height
        FilterPairItem {
            id: passwd_item
            pairName: "Password"
            width: parent.width
            height: 50
            markPlaceholderText: qsTr("Mark")
            inputEchoMode: TextInput.Password
            inputPlaceholderText: qsTr("Input")
        }

        Connections {
            target: ptyManager
            onMessageArrived: {
                if (! enable_box.checked) {
                    return;
                }

                // change password
                if (passwd_item.markText != "" && msg.startsWith(passwd_item.markText)) {
                    ptyManager.setMessage(passwd_item.inputText)
                }
            }
        }
    }

    Button {
        id: apply_option_btn
        width: 150
        height: 50
        text: qsTr("Apply Options")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
    }
}
