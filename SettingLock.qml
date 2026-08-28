import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3


Rectangle
{
    id: lockOverlay
    anchors.fill: parent
    color: Qt.rgba(0, 0, 0, 0.4)
    z: 10
    visible: false

    signal unlocked()
    signal closed()

    MouseArea
    {
        anchors.fill: parent
        preventStealing: true
    }

    Rectangle
    {
        color: "#FFFFFF"
        anchors.centerIn: parent
        border.width: 1
        width: 420
        height: 230

        ColumnLayout
        {
            id: infoSection
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width

            Text
            {
                text: qsTr("Access Restricted") + languagemanager.emptyString
                font.pixelSize: 20
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }

            Text
            {
                text: qsTr("Setting are locked for normal operation.") + languagemanager.emptyString
                font.pixelSize: 16
                font.family: "Helvetica Neue, Roboto, sans-serif"
                color: "#000000"
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }

            Text
            {
                text: qsTr("Please contact a technician for service or configuration.") + languagemanager.emptyString
                font.pixelSize: 16
                font.family: "Helvetica Neue, Roboto, sans-serif"
                color: "#000000"
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
        }

        ColumnLayout
        {
            id: pinSection
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: infoSection.bottom
            anchors.topMargin: 10
            width: parent.width
            spacing: 8

            TextField
            {
                id: pinField
                placeholderText: qsTr("Enter Technician PIN") + languagemanager.emptyString
                font.pixelSize: 16
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 200
            }

            Text
            {
                id: pinError
                text: qsTr("Incorrect PIN") + languagemanager.emptyString
                color: "#ed1f2d"
                font.pixelSize: 16
                visible: false
                Layout.alignment: Qt.AlignHCenter
            }
        }

        Rectangle
        {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 12
            anchors.top: pinSection.bottom
            anchors.topMargin: 10
            width: parent.width - 2

            RowLayout
            {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                Button
                {
                    id: passcodeConfirmButton
                    Layout.alignment: Qt.AlignVCenter
                    text: qsTr("Confirm") + languagemanager.emptyString
                    onClicked:
                    {
                        if (pinField.text == "1234")
                        {
                            pinField.text = ""
                            pinError.visible = false
                            lockOverlay.visible = false
                        } else
                        {
                            pinError.visible = true
                            pinField.text = ""
                        }
                    }
                }

                Button
                {
                    text: qsTr("Back") + languagemanager.emptyString
                    Layout.alignment: Qt.AlignVCenter
                    onClicked:
                    {
                        pinField.text = ""
                        pinError.visible = false
                        lockOverlay.visible = false
                        lockOverlay.closed()
                    }
                }
            }
        }
    }

    function open()
    {
        pinField.text = ""
        visible = true
    }
}
