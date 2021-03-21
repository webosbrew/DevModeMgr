import QtQuick 2.14

import DevModeMgr 1.0

Item {
    width: 640
    height: 480

    TableView {
        id: listView
        anchors.fill: parent
        columnSpacing: 1
        rowSpacing: 1
        clip: true

        model: DeviceListModel {
            json: DeviceManager.listDevices()
        }

        columnWidthProvider: function(column) {
            return -1;
        }

        delegate:  Text {
            text: display
        }

    }

}
