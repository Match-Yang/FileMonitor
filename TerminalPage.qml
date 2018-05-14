import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
Page {

    Flickable {
         id: flick

         width: 300; height: 200;
         contentWidth: show_text_edit.paintedWidth
         contentHeight: show_text_edit.paintedHeight
         clip: true
         anchors.fill: parent

         function ensureVisible(r)
         {
             if (contentX >= r.x)
                 contentX = r.x;
             else if (contentX+width <= r.x+r.width)
                 contentX = r.x+r.width-width;
             if (contentY >= r.y)
                 contentY = r.y;
             else if (contentY+height <= r.y+r.height)
                 contentY = r.y+r.height-height;
         }

         TextEdit {
             id: show_text_edit
             width: flick.width
             font.family: "Monospace"
             font.pointSize: 10
             color: Material.foreground
             selectByMouse: true
             selectByKeyboard: true
             text: configManager.fileName();
             wrapMode: TextEdit.Wrap
             onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
             Connections {
                 target: ptyManager
                 onMessageArrived: {
                     show_text_edit.text = show_text_edit.text + msg
                     show_text_edit.cursorPosition = show_text_edit.text.length
                     flick.ensureVisible(show_text_edit.cursorRectangle)
                 }
             }
             onWidthChanged: flick.ensureVisible(show_text_edit.cursorRectangle)
             onHeightChanged: flick.ensureVisible(show_text_edit.cursorRectangle)
         }

         ScrollBar.vertical: ScrollBar {}
     }


}
