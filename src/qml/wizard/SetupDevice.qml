import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 1.4

Item {
    anchors.fill: parent

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Column {
            width: parent.width
            spacing: 5

            Label {
                text: "Device Name"
            }

            TextField  {
                id: deviceName
                width: parent.width
                text: ""
            }
        }

        Row {
            width: parent.width
            spacing: 10
            Column {
                width: (parent.width - parent.spacing) / 3 * 2
                spacing: 5
                Label {
                    text: "Host Address"
                }
                TextField  {
                    id: deviceAddress
                    width: parent.width
                }

            }
            Column {
                width: (parent.width - parent.spacing) / 3 * 1
                spacing: 5
                Label {
                    text: "Port Number"
                }
                SpinBox {
                    id: devicePort
                    value: 9922
                    minimumValue: 0
                    maximumValue: 65535
                    width: parent.width
                }
            }
        }

        Row {
            width: parent.width
            spacing: 10
            Column {
                width: (parent.width - parent.spacing) / 2
                spacing: 5
                Label {
                    text: "Username"
                }
                TextField  {
                    id: username
                    width: parent.width
                    text: "prisoner"
                }

            }
            Column {
                width: (parent.width - parent.spacing) / 2
                spacing: 5
                Label {
                    text: "Passphrase"
                }
                TextField  {
                    id: passphrase
                    width: parent.width
                    placeholderText: qsTr("6 digits, in Dev Mode app")
                }
            }
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
