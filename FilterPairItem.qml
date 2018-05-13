import QtQuick 2.9
import QtQuick.Controls 2.2

Item {
    property alias markPlaceholderText: mark_text_field.placeholderText
    property alias markText: mark_text_field.text
    property alias inputPlaceholderText: input_text_field.placeholderText
    property alias inputText: input_text_field.text
    TextField {
        id: mark_text_field
        width: parent.width / 5 * 2
        height: parent.height
        selectByMouse: true
        anchors.left: parent.left
        anchors.leftMargin: 20
    }

    Text {
        id: split_colon
        width: 30
        height: parent.height
        text: " : "
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: mark_text_field.color
        anchors.left: mark_text_field.right
    }
    TextField {
        id: input_text_field
        width: parent.width / 5 * 2
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: 20
        selectByMouse: true
    }
}
