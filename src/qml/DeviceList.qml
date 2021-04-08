import QtQuick 2.10
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

import DevModeMgr 1.0

Item {

    TableView {
        id: tableView
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: bottomBar.top

            topMargin: 10
            leftMargin: 10
            rightMargin: 10
            bottomMargin: 10
        }
        model: DeviceListModel {
            function reload() {
                json = DeviceManager.listDevices()
            }
            function deviceAt(index) {
                return json[index];
            }
        }

        TableViewColumn {
            role: "name"
            title: "Name"
            width: 200
        }
        TableViewColumn {
            role: "ip"
            title: "IP"
            width: 100
        }
        TableViewColumn {
            role: "port"
            title: "Port"
            width: 50
        }
        TableViewColumn {
            role: "actions"
            title: ""
            delegate: RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Image {
                    source: "qrc:/ic_terminal.svg"
                    width: 20
                    height: 20
                    sourceSize.width: width
                    sourceSize.height: height
                    MouseArea {
                        anchors.fill: parent
                        onClicked: DeviceManager.openTerminal(tableView.model.deviceAt(styleData.row))
                    }
                }
                Image {
                    source: "qrc:/ic_edit.svg"
                    width: 20
                    height: 20
                    sourceSize.width: width
                    sourceSize.height: height
                }
                Button { text: "Delete" }
            }
        }

    }

    RowLayout  {
        id: bottomBar

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom

            leftMargin: 10
            rightMargin: 10
            bottomMargin: 10
        }

        Button {
            text: qsTr("Add device")
            onClicked: stackView.push(deviceSetupWizard)
        }
    }

    function reloadDevices() {
        tableView.model.reload()
    }
}
