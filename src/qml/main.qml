import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.12

ApplicationWindow {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("DevMode Manager")

    DeviceList {
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
            onClicked: {
                let component = Qt.createComponent("DeviceSetupWizard.qml");
                if( component.status !== Component.Ready )
                {
                    if( component.status === Component.Error )
                        console.debug("Error:"+ component.errorString() );
                    return; // or maybe throw
                }
                let setupwnd = component.createObject(root);

                setupwnd.show();
            }
        }
    }
}
