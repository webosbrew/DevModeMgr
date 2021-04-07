import QtQuick.Controls 1.4

import DevModeMgr 1.0

TableView {
    id: tableView
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

    model: DeviceListModel {
        json: DeviceManager.listDevices()
    }

}
