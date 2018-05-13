import QtQuick 2.9
import QtQuick.Controls 2.2

Item {
    property alias source: img.source
    property alias text: text_field.text
    property alias placeholderText: text_field.placeholderText

    AbstractButton {
        id: btn
        anchors.left: parent.left
        anchors.leftMargin: 10
        width: 50
        height: 50
        Image {
            id: img
            anchors.centerIn: parent
        }
    }

    TextField {
        id: text_field
        anchors.left: btn.right
        anchors.leftMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
    }
}
