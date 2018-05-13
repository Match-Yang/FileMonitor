import QtQuick 2.9
import QtQuick.Controls 2.2

Rectangle {
    color: "#1461b8"

    CheckBox {
        id: enable_box
        text: qsTr("Enable Auto Fill")
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 15
    }

    Column {
        enabled: enable_box.checked
        anchors.top: enable_box.bottom
        width: parent.width
        height: parent.height - enable_box.height - apply_option_btn.height
        FilterPairItem {
            id: passwd_item
            width: parent.width
            height: 50
            markPlaceholderText: qsTr("Mark")
            markText: "[sudo] password for"
            inputPlaceholderText: qsTr("Input")
            inputText: ""
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
