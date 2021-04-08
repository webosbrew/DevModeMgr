import QtQuick 2.10
import QtQuick.Window 2.10
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: root
    width: 960
    height: 600
    minimumWidth: 960
    minimumHeight: 600
    maximumWidth: minimumWidth
    maximumHeight: minimumHeight
    visible: true
    title: qsTr("DevMode Manager")

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: deviceList

        DeviceList {
            id: deviceList

            StackView.onActivated: deviceList.reloadDevices()
        }

        DeviceSetupWizard {
            id: deviceSetupWizard
        }
    }

}
