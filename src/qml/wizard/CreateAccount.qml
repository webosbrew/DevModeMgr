import QtQuick 2.0
import QtQml.Models 2.3

Item {
    anchors.fill: parent

    ListView {
        anchors.fill: parent
        anchors.margins: 10

        model: steps

        delegate: Text {
            text: title
        }
    }

    ListModel {
        id: steps

        ListElement {
            title: "Open \"Create Account\""
        }
        ListElement {
            title: "Select country"
        }
        ListElement {
            title: "Accept terms and conditions"
        }
        ListElement {
            title: "Verify email address"
        }
        ListElement {
            title: "Sign in to developer website"
        }
        ListElement {
            title: "Finish account creation"
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
