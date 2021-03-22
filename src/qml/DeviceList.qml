import QtQuick 2.14
import QtQuick.Controls 2.15
import Qt.labs.qmlmodels 1.0

import DevModeMgr 1.0

Item {
    width: 640
    height: 480

    TableView {
        id: tableView
        anchors.fill: parent
        columnSpacing: 1
        rowSpacing: 1
        clip: true

        model: DeviceListModel {
            json: DeviceManager.listDevices()
        }

        columnWidthProvider: function(column) {
            switch(column) {
            case 0: return tableView.width - ipColMetrics.boundingRect.width - portColMetrics.boundingRect.width
            case 1: return ipColMetrics.boundingRect.width
            case 2: return portColMetrics.boundingRect.width
            default: return -1;
            }
        }

        delegate: DelegateChooser {
            role: "type"
            DelegateChoice {
                roleValue: "header"
                Text {
                    text: display
                    font.bold: true
                }
            }
            DelegateChoice {
                roleValue: "item"
                Text {
                    text: display
                }
            }
        }

        TextMetrics {
            id: ipColMetrics
            text: '000.000.000.000'
        }

        TextMetrics {
            id: portColMetrics
            text: '00000'
        }

    }

}
