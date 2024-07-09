import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import local.DirectoryView

import "Constants.js" as Constants
import "Utils.js" as Utils

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Picture Renamer")

    ColumnLayout {

        anchors.fill: parent
        Row{
            Layout.fillWidth: true
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
            Layout.fillWidth: true
            id: row
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

        RowLayout{
            Layout.fillWidth: true
            Layout.fillHeight: true

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

            TreeView {
                id: view
                model: fileSystemModel
                rootIndex: rootPathIndex
                selectionModel: sel
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 300

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
                 // Detect F2 key press
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_F2) {
                        // if(!sel.hasSelection)
                        //     return;

                        let cur = sel.currentIndex;
                        if(cur < 0)
                            return;

                        if(!fileSystemModel.data(cur, DirectoryView.IsImage))
                            return;

                        let url = fileSystemModel.data(cur, DirectoryView.UrlStringRole)

                        var newName = promptRename(url)
                        if (newName)
                            renameFile(currentFilePath, newName)
                    } else if (event.key === Qt.Key_Delete) {
                        let cur = sel.currentIndex;
                        if(cur < 0)
                            return;

                        if(!fileSystemModel.data(cur, DirectoryView.IsImage))
                            return;

                        let url = fileSystemModel.data(cur, DirectoryView.UrlStringRole)

                        url = Utils.stripPrefix(Constants.filePrefix, url);
                        fileHandler.deleteFile(url);
                    }
                }


                Dialog {
                    id: renameDialog
                    modal: true
                    title: "Rename File"
                    standardButtons: Dialog.Cancel | Dialog.Ok
                    onAccepted: renameFile(renameDialog.currentFilePath, renameTextField.text)

                    onOpened: (evt) =>{
                        // var rawText = renameTextField.text;
                        // var baseName = rawText.substring(0, rawText.lastIndexOf('.'));

                        // renameTextField.forceActiveFocus(); // Set focus programmatically
                        // renameTextField.select(0, baseName.Length);
                    }

                    ColumnLayout {
                        Label {
                            text: "Enter new name:"
                        }
                        TextField {
                            id: renameTextField
                            Layout.fillWidth: true
                            selectByMouse: true
                            Keys.onReturnPressed: (evt) => {
                                renameDialog.accept();
                                renameDialog.close();
                            }
                            Keys.onEscapePressed: (evt) => {
                                renameDialog.close();
                            }

                            Component.onCompleted: {
                                var rawText = renameTextField.text;
                                var baseName = rawText.substring(0, rawText.lastIndexOf('.'));

                                //renameTextField.select(0, baseName.Length);
                                renameTextField.selectAll();
                                renameTextField.cursorPosition = baseName.Length;
                                forceActiveFocus(); // Set focus programmatically
                            }
                        }
                    }

                    function renameFile(oldPath, newName) {
                        oldPath = Utils.stripPrefix(Constants.filePrefix, oldPath);

                        var newPath = oldPath.substring(0, oldPath.lastIndexOf('/') + 1) + newName
                        console.log("Renaming: " + oldPath + " to " + newPath)
                        fileHandler.renameFile(oldPath, newName);
                    }

                    property string currentFilePath: ""

                }

                function promptRename(filePath) {
                    renameTextField.text = filePath.split('/').pop() // Set current file name
                    renameDialog.currentFilePath = filePath;
                    var result = renameDialog.open()
                }

            }

            Image {
                Layout.fillWidth: true
                Layout.fillHeight: true
                id: image
                fillMode: Image.PreserveAspectFit
            }

        }
    }
}
