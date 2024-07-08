import QtQuick
import QtQuick.Controls

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Column {
        FileTree {
            id: fileTree
            height: parent.height
            width: parent.width * 0.25
        }
    }

    Column {
        Image {
            id: image
            height: parent.height
            width: parent.width
        }
    }

}
