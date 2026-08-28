import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page
{
    id: settingPage

    signal confirmSubmitted(string ip, string port)

    background: Rectangle
    {
        color: "#e2e8d8"
    }

    ColumnLayout
    {
        anchors.fill: parent
        anchors.centerIn: parent

        RowLayout
        {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop | Qt.AlignVCenter

            Rectangle
            {
                color: "white"
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter | Qt.AlignTop
                radius: 7
                Layout.margins: 10
                Layout.preferredHeight: 230
                Layout.preferredWidth: 370

                ColumnLayout
                {
                    anchors.fill: parent

                    Label
                    {
                        text: qsTr("ModbusTCP Setting")
                        font.pixelSize: 22
                        Layout.alignment: Qt.AlignTop |Qt.AlignLeft
                        Layout.margins: 10
                        Layout.bottomMargin: 0

                        Layout.maximumWidth: 250
                        elide: Text.ElideRight
                    }

                    TextField
                    {
                        id: ipInput
                        text: modbusManager.ipFromSetting
                        font.bold: true
                        font.pixelSize: 15
                        placeholderText: qsTr("IP Address")

                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft
                        Layout.margins: 10
                        Layout.bottomMargin: 5
                        Layout.topMargin: 5
                        Layout.preferredHeight: 40
                        Layout.preferredWidth: 200
                        enabled: true
                    }

                    TextField
                    {
                        id: portInput
                        text: modbusManager.portFromSetting
                        font.bold: true
                        font.pixelSize: 15
                        placeholderText: qsTr("Port")

                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft
                        Layout.preferredHeight: 40
                        Layout.preferredWidth: 200
                        Layout.margins: 10
                        Layout.bottomMargin: 5
                        Layout.topMargin: 5
                        inputMethodHints: Qt.ImhDigitsOnly
                        enabled: true
                    }

                    RowLayout
                    {
                        Layout.fillWidth: true
                        spacing: 10

                        Button
                        {
                            id: submitButton
                            text: qsTr("Confirm")

                            Layout.alignment: Qt.AlignLeft
                            Layout.preferredWidth: 80
                            Layout.preferredHeight: 30
                            Layout.margins: 5
                            Layout.topMargin: 0
                            Layout.leftMargin: 10
                            Layout.bottomMargin: 10


                            contentItem: Text
                            {
                                text: parent.text
                                font.pixelSize: 15
                                color: "#000000"
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            background: Rectangle
                            {
                                border.color: "#000000"
                                border.width: 1
                                color: parent.down ? "#d6d4d4" : "#FFFFFF"
                            }

                            onClicked:
                            {
                                modbusManager.setDevIp(ipInput.text);
                                modbusManager.setDevPort(parseInt(portInput.text));
                                modbusManager.connectToDevice(modbusManager.ipFromSetting,
                                                              modbusManager.portFromSetting);
                            }
                        }

                        Button
                        {
                            id: resetButton
                            text: qsTr("Reset")

                            Layout.preferredWidth: 80
                            Layout.preferredHeight: 30
                            Layout.margins: 5
                            Layout.topMargin: 0
                            Layout.bottomMargin: 10

                            contentItem: Text
                            {
                                text: parent.text
                                font.pixelSize: 15
                                color: "#000000"
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            background: Rectangle
                            {
                                border.color: "#000000"
                                border.width: 1
                                color: parent.down ? "#d6d4d4" : "#FFFFFF"
                            }
                        }
                    }
                }
            }

            Rectangle
            {
                color: "white"
                radius: 7
                Layout.preferredHeight: 230
                Layout.preferredWidth: 370

                ColumnLayout
                {
                    anchors.fill: parent

                    Label
                    {
                        Layout.alignment: Qt.AlignTop
                        Layout.margins: 10
                        Layout.bottomMargin: 5
                        text: "Network Configuration"
                        font.family: "Helvetica Neue, Roboto, sans-serif"
                        font.pixelSize: 22
                    }

                    ComboBox
                    {
                        id: interfaceCombo
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                        Layout.leftMargin: 10
                        Layout.preferredWidth: parent.width * 0.8
                        model: networkHelper.getEthernetConnections()

                        contentItem: Text
                        {
                            text: interfaceCombo.currentText
                            font.pixelSize: 18
                            verticalAlignment: Text.verticalAlignment
                            color: "#000000"
                            font.family: "Helvetica Neue, Roboto, sans-serif"
                        }

                        onCurrentTextChanged:
                        {
                            currentIpText.text = networkHelper.getIpForConnection(interfaceCombo.currentText)
                        }
                    }


                    TextField
                    {
                        id: inputIpTextField
                        Layout.fillWidth: true
                        Layout.margins: 10
                        Layout.topMargin: 0
                        Layout.bottomMargin: 5
                        placeholderText: "New Static IP"
                        font.pixelSize: 23
                        font.family: "Helvetica Neue, Roboto, sans-serif"
                    }

                    TextField
                    {
                        id: gatewayInput
                        Layout.fillWidth: true
                        Layout.margins: 10
                        Layout.topMargin: 0
                        Layout.bottomMargin: 0
                        placeholderText: "Gateway"
                        font.pixelSize: 23
                        font.family: "Helvetica Neue, Roboto, sans-serif"
                    }

                    Button
                    {
                        Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                        text: "Apply"
                        Layout.leftMargin: 10
                        Layout.bottomMargin: 10
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 30

                        background: Rectangle
                        {
                            border.width: 1
                        }

                        contentItem: Text
                        {
                            font.pixelSize: 16
                            font.bold: true
                            text: parent.text
                            color: "#000000"
                            font.family: "Helvetica Neue, Roboto, sans-serif"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked:
                        {
                            var selectedConn = interfaceCombo.currentText;
                            if (!selectedConn)
                            {
                                console.log("NO interface selected.")
                                return;
                            }

                            var success = networkHelper.setStaticIp(selectedConn, inputIpTextField.text, gatewayInput.text);
                            if (success)
                            {
                                var currentIp = networkHelper.getIpFromConnection(selectedConn);
                                currentIpText.text = currentIp;
                            } else
                            {
                                console.log("Failed to set static IP");
                            }
                        }
                    }
                }
            }

            Rectangle
            {
                color: "white"
                radius: 7
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter | Qt.AlignTop
                Layout.margins: 10

                ColumnLayout
                {
                    anchors.fill: parent

                    Text
                    {
                        text: "current IP"
                        Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                        Layout.margins: 10
                        font.pixelSize: 23
                        font.family: "Helvetica Neue, Roboto, sans-serif"
                    }

                    Rectangle
                    {
                        Layout.alignment: Qt.AlignLeft
                        Layout.margins: 10
                        Layout.preferredHeight: parent.height * 0.2
                        Layout.preferredWidth: parent.width
                        border.width: 1
                        border.color: "#000000"

                        Text
                        {
                            anchors.fill: parent
                            verticalAlignment: Text.verticalAlignment
                            id: currentIpText
                            text: "N/A"
                            font.pixelSize: 18
                            font.family: "Helvetica Neue, Roboto, sans-serif"
                        }
                    }
                }
            }
        }

        RowLayout
        {
            Layout.fillWidth: true
            spacing: 20
            Layout.alignment: Qt.AlignHCenter

            Button
            {
                id: homeButton
                text: qsTr("HOME")
                Layout.preferredWidth: 125
                Layout.preferredHeight: 55
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

                background: Rectangle
                {
                    implicitWidth: 130
                    implicitHeight: 50
                    color: "white"
                    radius: 5
                }

                contentItem: Text
                {
                    text: homeButton.text
                    color: "#000000"
                    font.bold: true
                    font.pixelSize: 24
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked:
                {
                    stackView.replace("HomePage.qml");
                }
            }

            Button
            {
                id: controlButton
                text: qsTr("Controls")
                Layout.preferredWidth: 125
                Layout.preferredHeight: 55
                Layout.alignment: Qt.AlignVCenter

                background: Rectangle
                {
                    implicitHeight: 120
                    implicitWidth: 120
                    color: "white"
                    radius: 5
                }

                contentItem: Text
                {
                    text: controlButton.text
                    color: "#000000"
                    font.bold: true
                    font.pixelSize: 24
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked:
                {
                    stackView.replace("ControlPage.qml")
                }
            }
        }
    }

    Component.onCompleted:
    {
        lockScreen.open()
    }

    SettingLock
    {
        id: lockScreen


        onClosed:
        {
            stackView.replace("ControlPage.qml")
        }
    }
}
