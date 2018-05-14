import QtQuick 2.9
import QtQuick.Controls 2.2

Item {
    property alias markPlaceholderText: mark_text_field.placeholderText
    property alias markText: mark_text_field.text
    property alias inputPlaceholderText: input_text_field.placeholderText
    property alias inputText: input_text_field.text
    // TODO save data encode if inputEchoMode is password mode
    property alias inputEchoMode: input_text_field.echoMode

    property string pairName: ""

    TextField {
        id: mark_text_field

        property string old_text: ""

        width: parent.width / 5 * 2
        height: parent.height
        selectByMouse: true
        anchors.left: parent.left
        anchors.leftMargin: 20

        onTextChanged: {
            if (text == "") {
                return
            }

            configManager.setValue(pairName, "PairMark", text)
        }

        // record old_text on init
        Component.onCompleted: {
            text = configManager.value(pairName, "PairMark", "")
        }
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
        text: configManager.value(pairName, "PairInput", "")
        onTextChanged: {
            if (text != "") {
                configManager.setValue(pairName, "PairInput", text)
            }
        }
    }
}
