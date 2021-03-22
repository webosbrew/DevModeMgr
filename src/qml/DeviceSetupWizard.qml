import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQml 2.15

ApplicationWindow {
    width: 960
    height: 600
    visible: true
    title: qsTr("Device Setup")

    ListView {
        id: wizardSteps
        width: parent.width / 3
        anchors {
            left: parent.left
            top: parent.top
            bottom: bottomBar.top

            topMargin: 10
            leftMargin: 10
            bottomMargin: 10
        }

        onCurrentItemChanged: {
            pageLoader.source = pages.get(currentIndex).page
        }

        model: pages
        spacing: 5
        delegate:
            Text {
            text: name

            anchors {
                left: parent.left
                right: parent.right
            }

            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            font.bold: wizardSteps.currentIndex == index
            opacity: wizardSteps.currentIndex >= index ? 1 : 0.5

            MouseArea {
                anchors.fill: parent
                onClicked: wizardSteps.currentIndex = index
            }
        }
    }

    Rectangle {
        id: wizardDetails
        anchors {
            top: parent.top
            left: wizardSteps.right
            bottom: bottomBar.top
            right: parent.right

            topMargin: 10
            leftMargin: 10
            rightMargin: 10
            bottomMargin: 10
        }
        border {
            color: "black"
            width: 1
        }

        Loader {
            id: pageLoader
            anchors.fill: parent
        }

    }
    RowLayout {
        id: bottomBar
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom

            leftMargin: 10
            rightMargin: 10
            bottomMargin: 10
        }

        Item {
            Layout.fillWidth: true
        }

        Button {
            text: "Go Back"
            visible: wizardSteps.currentIndex > 0
            onClicked: wizardSteps.currentIndex = wizardSteps.currentIndex - 1
        }

        Button {
            text: "Continue"
            visible: wizardSteps.currentIndex < pages.rowCount() - 1
            onClicked: wizardSteps.currentIndex = wizardSteps.currentIndex + 1
        }

        Button {
            text: "Finish"
            visible: wizardSteps.currentIndex == pages.rowCount() - 1
            onClicked: close()
        }
    }

    ListModel {
        id: pages
        ListElement {
            name: "Prepare Developer Account"
            page: "wizard/CreateAccount.qml"
        }
        ListElement {
            name: "Install Developer Mode App"
            page: "wizard/InstallDevMode.qml"
        }
        ListElement {
            name: "Enable Developer Mode"
            page: "wizard/EnableDevMode.qml"
        }
        ListElement {
            name: "Enable Key Server"
            page: "wizard/EnableKeyServer.qml"
        }
        ListElement {
            name: "Search Device"
            page: "wizard/SearchDevice.qml"
        }
        ListElement {
            name: "Setup Device"
            page: "wizard/SetupDevice.qml"
        }
        ListElement {
            name: "Check Device Setup"
            page: "wizard/DeviceChecker.qml"
        }
    }
}
