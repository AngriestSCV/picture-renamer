import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import local.DirectoryView

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Picture Renamer")


    Row{
        MenuBar {
            Menu {
                title: qsTr("File")
                MenuItem {
                    text: qsTr("Exit")
                    onTriggered: Qt.quit();
                }
            }
        }
    }


    Row {
        id: row
        anchors.top: parent.top
        anchors.topMargin: 12
        anchors.horizontalCenter: parent.horizontalCenter

           Repeater {
            model: [ "None", "Single", "Extended", "Multi", "Contig."]
            Button {
                text: modelData
                checkable: true
                checked: index === 1
                onClicked: view.selectionMode = index
            }
        }
    }

    ItemSelectionModel {
        id: sel
        model: fileSystemModel
        onCurrentChanged: (cur) => {
            if(fileSystemModel.data(cur, DirectoryView.IsImage))
            {
                var url = fileSystemModel.data(cur, DirectoryView.UrlStringRole)
                //Qt.openUrlExternally(url)
                image.source = url;
            }
        }
    }


    ColumnLayout{
        Column {
            TreeView {
                id: view
                anchors.fill: parent
                anchors.margins: 2 * 12 + row.height
                model: fileSystemModel
                rootIndex: rootPathIndex
                selectionModel: sel

                delegate: Item {
                     implicitWidth: padding + label.x + label.implicitWidth + padding
                     implicitHeight: label.implicitHeight * 1.2

                     readonly property real indentation: 20
                     readonly property real padding: 5

                     // Assigned to by TreeView:
                     required property TreeView treeView
                     required property bool isTreeNode
                     required property bool expanded
                     required property int hasChildren
                     required property int depth
                     required property int row
                     required property int column
                     required property bool current

                     // Rotate indicator when expanded by the user
                     // (requires TreeView to have a selectionModel)
                     property Animation indicatorAnimation: NumberAnimation {
                         target: indicator
                         property: "rotation"
                         from: expanded ? 0 : 90
                         to: expanded ? 90 : 0
                         duration: 100
                         easing.type: Easing.OutQuart
                     }
                     TableView.onPooled: indicatorAnimation.complete()
                     TableView.onReused: if (current) indicatorAnimation.start()
                     onExpandedChanged: indicator.rotation = expanded ? 90 : 0

                     Rectangle {
                         id: background
                         anchors.fill: parent
                         color: row === treeView.currentRow ? palette.highlight : "black"
                         opacity: (treeView.alternatingRows && row % 2 !== 0) ? 0.3 : 0.1
                     }

                     Label {
                         id: indicator
                         x: padding + (depth * indentation)
                         anchors.verticalCenter: parent.verticalCenter
                         visible: isTreeNode && hasChildren
                         text: "▶"

                         TapHandler {
                             onSingleTapped: {
                                 let index = treeView.index(row, column)
                                 treeView.selectionModel.setCurrentIndex(index, ItemSelectionModel.NoUpdate)
                                 treeView.toggleExpanded(row)
                             }
                         }
                     }

                    Label {
                         id: label
                         x: padding + (isTreeNode ? (depth + 1) * indentation : 0)
                         anchors.verticalCenter: parent.verticalCenter
                         width: parent.width - padding - x
                         clip: true
                         text: model.display
                     }
                }
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
}
