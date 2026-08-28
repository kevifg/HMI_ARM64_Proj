import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page
{
    id: controlPage

   Image
   {
        id: bg
        source: "qrc:/assets/nature_bg_mountains.PNG"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        asynchronous: true

        Rectangle
        {
            color: Qt.rgba(0, 0, 0, 0.1)
        }
   }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 15

        RowLayout
        {
            spacing: 35
            Layout.alignment: Qt.AlignTop
            Layout.fillWidth: true
            Layout.margins: 18

            Item
            {
                id: oxygen_1
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                implicitHeight: 380

//                ShaderEffectSource
//                {
//                    id: captureBg
//                    anchors.fill: parent
//                    sourceItem: bg
//                    sourceRect: Qt.rect(oxygen_1.x, oxygen_1.y, oxygen_1.width, oxygen_1.height)
//                    visible: false
//                }

//                FastBlur
//                {
//                    id: blurredBg
//                    anchors.fill: parent
//                    source: captureBg
//                    radius: 50
//                    cached: true
//                }

//                Rectangle
//                {
//                    id: maskShape
//                    anchors.fill: parent
//                    radius: 20
//                    visible: false
//                }

//                OpacityMask
//                {
//                    anchors.fill: parent
//                    source: blurredBg
//                    maskSource: maskShape
//                }

                Rectangle
                {
                    anchors.fill: parent
                    radius: 20
                    color: Qt.rgba(1, 1, 1, 0.15)
                    border.color: Qt.rgba(1, 1, 1, 0.3)
                    border.width: 1
                }

                ColumnLayout
                {
                    anchors.fill:parent

                    Text
                    {
                        text: qsTr("OXYGEN 1") + languagemanager.emptyString
                        color: "#F2F7F4"
                        font.family: "Helvetica Neue, Roboto, sans-serif"
                        font.bold: true
                        font.pixelSize: 36
                        Layout.topMargin: 10
                        Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                    }

                    Switch
                    {
                        id: oxy1Switch
                        checked: modbusManager.oxy1Opened

                        onCheckedChanged:
                        {
                            if (checked)
                            {
                                modbusManager.writeSingleCoil(1, true, 1);

                            } else
                            {
                                modbusManager.writeSingleCoil(1, false, 1);
                            }
                        }

                        Layout.alignment: Qt.AlignHCenter

                        implicitWidth: 110
                        implicitHeight: 110

                        indicator: Rectangle
                        {
                            id: oxy1SwitchTrack
                            implicitWidth: 110
                            implicitHeight: 110
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: 0

                            radius: 7

                            color: oxy1Switch.checked ? "#1be386" : "#ff746c"
                            //border.color: "#3d4240" // dark gray

                            Text
                            {
                                id: oxy1SwitchTopText
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right

                                text: qsTr("OFF") + languagemanager.emptyString
                                font.pixelSize: 35
                                font.bold: true
                                font.letterSpacing: 1.0
                                color: "#000000"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                                opacity: oxy1Switch.checked ? 0 : 1
                            }

                            Text
                            {
                                id: oxy1SwitchBottomText
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right

                                text: qsTr("ON") + languagemanager.emptyString
                                font.pixelSize: 35
                                font.bold: true
                                font.family: "Monospace"
                                font.letterSpacing: 1.0
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                                opacity: oxy1Switch.checked ? 1 : 0
                            }

                            Behavior on color
                            {
                                ColorAnimation {duration: 200}
                            }
                        }


                        Rectangle
                        {
                            id: oxy1SwitchHandle
                            width: 108
                            height: 55
                            radius: 6
                            anchors.horizontalCenter: parent.horizontalCenter

                            y: oxy1Switch.checked ? 2 : oxy1SwitchTrack.height - height - 2

                            color: "#FFFFFF"
                            border.color: "#B0BEC5"
                            border.width: 1

                            Rectangle
                            {
                                anchors.top: parent.top
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: parent.width -18
                                height: 2
                                radius: 2
                                color: "#a7a8a7"
                                opacity: 0.3
                            }

                            Behavior on y
                            {
                                NumberAnimation
                                {
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }
                }
            }

            Item
            {
                id: oxygen_2
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                implicitHeight: 380

//                ShaderEffectSource
//                {
//                    id: captureBg_2
//                    anchors.fill: parent
//                    sourceItem: bg
//                    sourceRect: Qt.rect(oxygen_2.x, oxygen_2.y, oxygen_2.width, oxygen_2.height)
//                    visible: false // hide raw source
//                }

//                FastBlur
//                {
//                    id: blurredBg_2
//                    anchors.fill: parent
//                    source: captureBg_2
//                    radius: 64
//                    cached: true
//                    visible: false // hide square blur
//                }

//                Rectangle
//                {
//                    id: maskShape_2
//                    anchors.fill: parent
//                    radius: 20
//                    visible: false
//                }

//                OpacityMask
//                {
//                    anchors.fill: parent
//                    source: blurredBg_2
//                    maskSource: maskShape_2
//                }

                Rectangle
                {
                    anchors.fill: parent
                    radius: 20
                    color: Qt.rgba(1, 1, 1, 0.15)
                    border.color: Qt.rgba(1, 1, 1, 0.3)
                    border.width: 1
                }

                ColumnLayout
                {
                    anchors.fill:parent

                    Text
                    {
                        text: qsTr("OXYGEN 2") + languagemanager.emptyString
                        color: "#F2F7F4"
                        font.family: "Helvetica Neue, Roboto, sans-serif"
                        font.bold: true
                        font.pixelSize: 36
                        Layout.topMargin: 10
                        Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                    }

                    Switch
                    {
                        id: oxy2Switch
                        checked: modbusManager.oxy2Opened
                        Layout.alignment: Qt.AlignHCenter

                        implicitWidth: 110
                        implicitHeight: 110

                        onCheckedChanged:
                        {
                            if (checked)
                            {
                                modbusManager.writeSingleCoil(2, true, 2);
                            } else
                            {
                                modbusManager.writeSingleCoil(2, false, 2);
                            }
                        }

                        indicator: Rectangle
                        {
                            id: oxy2SwitchTrack
                            implicitWidth: 110
                            implicitHeight: 110
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: 0

                            radius: 7
                            color: oxy2Switch.checked ? "#1be386" : "#ff746c"

                            Text
                            {
                                id: oxy2SwitchTopText
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right

                                text: qsTr("OFF") + languagemanager.emptyString
                                font.pixelSize: 35
                                font.bold: true
                                font.letterSpacing: 1.0
                                color: "#000000"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                                opacity: oxy2Switch.checked ? 0 : 1
                            }

                            Text
                            {
                                id: oxy2SwitchBottomText
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right

                                text: qsTr("ON") + languagemanager.emptyString
                                font.pixelSize: 35
                                font.bold: true
                                font.family: "Monospace"
                                font.letterSpacing: 1.0
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                                opacity: oxy2Switch.checked ? 1 : 0
                            }

                            Behavior on color
                            {
                                ColorAnimation {duration: 200}
                            }
                        }


                        Rectangle
                        {
                            id: oxy2SwitchHandle
                            width: 108
                            height: 55
                            radius: 6
                            anchors.horizontalCenter: parent.horizontalCenter

                            y: oxy2Switch.checked ? 2 : oxy2SwitchTrack.height - height - 2

                            color: "#FFFFFF"
                            border.color: "#B0BEC5"
                            border.width: 1

                            Rectangle
                            {
                                anchors.top: parent.top
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: parent.width -18
                                height: 2
                                radius: 2
                                color: "#a7a8a7"
                                opacity: 0.3
                            }

                            Behavior on y
                            {
                                NumberAnimation
                                {
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }
                }
            }

            Item
            {
                id: vac_1
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                implicitHeight: 380

//                ShaderEffectSource
//                {
//                    id: captureBg_3
//                    anchors.fill: parent
//                    sourceItem: bg
//                    sourceRect: Qt.rect(vac_1.x, vac_1.y, vac_1.width, vac_1.height)
//                    visible: false
//                }

//                FastBlur
//                {
//                    id: blurredBg_3
//                    source: captureBg_3
//                    radius: 64
//                    cached: true
//                    visible: false
//                }

//                Rectangle
//                {
//                    id:maskShape_3
//                    anchors.fill: parent
//                    radius: 20
//                    visible: false
//                }

//                OpacityMask
//                {
//                    anchors.fill: parent
//                    source: blurredBg_3
//                    maskSource: maskShape_3
//                }

                Rectangle
                {
                    anchors.fill: parent
                    radius: 20
                    color: Qt.rgba(1, 1, 1, 0.15)
                    border.color: Qt.rgba(1, 1, 1, 0.3)
                    border.width: 1
                }

                ColumnLayout
                {
                    anchors.fill: parent

                    Text
                    {
                        text: qsTr("VACCUM") + languagemanager.emptyString
                        color: "#FFFFFF"
                        font.family: "Helvetica Neue, Roboto, sans-serif"
                        font.bold: true
                        font.pixelSize: 36
                        Layout.topMargin: 10
                        Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
                    }

                    Switch
                    {
                        id: vacSwitch
                        implicitHeight: 110
                        implicitWidth: 110
                        checked: modbusManager.vacOpened;

                        Layout.alignment: Qt.AlignHCenter

                        onCheckedChanged:
                        {
                            if (checked)
                            {
                                modbusManager.writeSingleCoil(3, true, 3);
                            } else
                            {
                                modbusManager.writeSingleCoil(3, false, 3);
                            }
                        }

                        indicator: Rectangle
                        {
                            id: vacSwitchTrack
                            implicitHeight: 110
                            implicitWidth:110
                            radius: 7
                            anchors.horizontalCenter: parent.horizontalCenter
                            y:0

                            color: vacSwitch.checked ? "#1be386" : "#ff736c"

                            Text
                            {
                                id: vacSwitchTopText
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.right: parent.right

                                text: qsTr("OFF") + languagemanager.emptyString
                                font.pixelSize: 35
                                font.bold: true
                                font.letterSpacing: 1.0
                                color: "#000000"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                                opacity: vacSwitch.checked ? 0 : 1
                            }

                            Text
                            {
                                id: vacSwitchButtomText
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.right: parent.right

                                text: qsTr("ON") + languagemanager.emptyString
                                font.pixelSize: 35
                                font.bold: true
                                color: "#000000"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                                opacity: vacSwitch.checked ? 1 : 0
                            }
                        }

                        Rectangle
                        {
                            id:vacSwitchHandle
                            width: 108
                            height: 55
                            radius: 6
                            anchors.horizontalCenter: parent.horizontalCenter

                            y: vacSwitch.checked ? 2 : parent.height - height - 2

                            color: "#FFFFFF"
                            border.color: "#B0BEC5"
                            border.width: 1

                            Rectangle
                            {
                                anchors.top: parent.top
                                anchors.horizontalCenter: parent.horizontalCenter
                                width: parent.width -18
                                height: 2
                                radius: 2
                                color: "#a7a8a7"
                                opacity: 0.3
                            }

                            Behavior on y
                            {
                                NumberAnimation
                                {
                                    duration: 200
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }
                }
            }
        }

        RowLayout
        {
            id: navRow
            spacing: 20
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 10

            Button
            {
                id: homeButton
                text: qsTr("HOME") + languagemanager.emptyString
                Layout.preferredWidth: 125
                Layout.preferredHeight: 55
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

                background: Rectangle
                {
                    implicitWidth: 130
                    implicitHeight: 50
                    color: Qt.rgba(1, 1, 1, 0.9)
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
                id: settingButton
                text: qsTr("SETTING") + languagemanager.emptyString
                Layout.preferredWidth: 125
                Layout.preferredHeight: 55
                Layout.alignment: Qt.AlignVCenter

                background: Rectangle
                {
                    implicitHeight: 120
                    implicitWidth: 120
                    color: Qt.rgba(1, 1, 1, 0.9)
                    radius: 5
                }

                contentItem: Text
                {
                    text: settingButton.text
                    color: "#000000"
                    font.bold: true
                    font.pixelSize: 24
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked:
                {
                    stackView.replace("SettingPage.qml");
                }
            }
        }
    }
}
