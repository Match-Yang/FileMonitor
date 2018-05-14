import QtQuick 2.9
import QtQuick.Controls 2.2

Rectangle {
    color: "#1461b8"

    readonly property string _config_group: "FilterPair"

    CheckBox {
        id: enable_box
        text: qsTr("Enable Auto Fill")
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 15
        checked: configManager.value(_config_group, "EnableFilter", true)
        onCheckedChanged: {
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
