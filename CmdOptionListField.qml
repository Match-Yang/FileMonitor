import QtQuick 2.9
import QtQuick.Controls 2.2

Rectangle {
    color: "#1461b8"

    CheckBox {
        text: qsTr("Enable Auto Fill")
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 15
    }
}
