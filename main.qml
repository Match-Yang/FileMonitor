import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {
    visible: true
    width: 1024
    height: 600
    title: qsTr("")

    ConfigPage {
        id: conf_page
        width: 400
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
    }

    TerminalPage {
        id: term_page
        width: parent.width - conf_page.width
        height: parent.height
        anchors.right: parent.right
    }

}
