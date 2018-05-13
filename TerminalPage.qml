import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
Page {

    TextEdit {
        color: Material.foreground
        selectByMouse: true
        selectByKeyboard: true
        text: configManager.fileName();
    }
}
