import QtQuick 2.6
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0

Rectangle {
    width: parent.width
    height: parent.height
    color: "grey"
    //Automatically connect on startup if decoded
    //Component.onCompleted:  Serial.openConnection(serialName.currentText, ecuSelect.currentIndex, interfaceSelect.currentIndex)


Item {
    id: powerTuneSettings

    Settings {
        property alias connectAtStartUp: connectAtStart.checkState
        property alias serialPortName: serialName.currentText
        property alias ecuType: ecuSelect.currentText
        property alias powerFcInterface: interfaceSelect.currentText
    }

    Row {
        x: 5
        y: 5
        spacing: 5
        Grid {
            rows: 10
            columns: 2
            spacing: 5
            // [0]
            Text { text: "Serial port name: " }
            ComboBox {
                id: serialName
                width: 200

                model: Serial.portsNames
                //property bool initialized: false
                onCurrentIndexChanged: if (initialized) AppSettings.setBaudRate( currentIndex )
                Component.onCompleted: { currentIndex = AppSettings.getBaudRate(); initialized = true }
           }

            Text { text: "ECU Selection:" }
            ComboBox {
                id: ecuSelect
                width: 200

                model: [ "PowerFC", "Adaptronic"]
                //property bool initialized: false
                onCurrentIndexChanged: if (initialized) AppSettings.setECU( currentIndex )
                Component.onCompleted: { currentIndex = AppSettings.getECU(); initialized = true }
            }
            Text {
                id: textinterfaceSelect
                visible: { (ecuSelect.currentIndex == "1") ? false: true; }
                text: "PowerFC Interface:"

            }
            ComboBox {
                id: interfaceSelect
                visible: { (ecuSelect.currentIndex == "1") ? false: true; }
                width: 200
                model: [ "FcHako", "Datalogit"]
                property bool initialized: false
                onCurrentIndexChanged: if (initialized) AppSettings.setInterface( currentIndex )
                Component.onCompleted: { currentIndex = AppSettings.getInterface(); initialized = true }
            }
        }

        Grid {
            rows: 10
            columns: 2
            spacing: 5

        Button {
            text: "Connect"
            onClicked: {
                Serial.openConnection(serialName.currentText, ecuSelect.currentIndex, interfaceSelect.currentIndex)
            }
        }
        Button {
            text: "Disconnect"
            onClicked: {
                Serial.closeConnection()
            }
        }
        Button {
            text: "Clear"
            onClicked: {
                Serial.clear()
            }
        }
        Button {
            text: "Quit"
            onClicked: {
                Qt.quit()
            }
        }
            CheckBox {
            id: connectAtStart
            text: qsTr("Autoconnect at startup")

        }

        }
    }
}
}


