import QtQuick.Controls 1.4

import DevModeMgr 1.0

TableView {
    id: tableView
    TableViewColumn {
        role: "name"
        title: "Name"
        width: 100
    }
    TableViewColumn {
        role: "ip"
        title: "IP"
        width: 200
    }

    model: DeviceListModel {
        json: DeviceManager.listDevices()
    }

}
