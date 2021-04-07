import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 1.4

import DevModeMgr 1.0

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
                text: "hometv"
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
                    text: "192.168.4.104"
                    validator: RegExpValidator { regExp: /^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$/ }
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
                    maximumLength: 6
                    text: "FA8A17"
                    placeholderText: qsTr("6 digits, in Dev Mode app")
                    validator: RegExpValidator { regExp: /[A-Z0-9]{6}/ }
                }
            }
        }
    }

    Loader {
        id: addDeviceTask
        active: false
        asynchronous: true

        property var callback: null
        property var privatekey: null

        onLoaded: {
            if (callback)
                callback(item.result);
            callback = null;
        }

        sourceComponent: Item {
            property var result: null;
            Component.onCompleted: {
                if (!privatekey) {
                    result = false;
                    return;
                }

                var arguments = {
                    'device': deviceName.text,
                    'host': deviceAddress.text,
                    'port': devicePort.value,
                    'username': username.text,
                    'passphrase': passphrase.text,
                    'privatekey': privatekey
                };
                result = DeviceManager.addDevice(arguments);
            }
        }
    }

    PrivKeyDownloadCallback {
        id: privKeyCallback

        onFinished: {
            // PrivKey downloaded, proceed with adding device
            addDeviceTask.privatekey = privateKey
            addDeviceTask.active = true;
        }

        onErrored: {

        }
    }

    function canContinue() {
        return deviceName.acceptableInput && deviceAddress.acceptableInput &&
                username.acceptableInput && passphrase.acceptableInput;
    }

    function doContinue(cb) {
        addDeviceTask.callback = cb;
        // First, download privKey from key server
        DeviceManager.downloadPrivKey(deviceAddress.text, deviceName.text, privKeyCallback);
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
