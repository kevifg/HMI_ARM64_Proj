import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Page
{
    id: homePage

    Image
    {
        id: backgroundImage
        anchors.fill: parent

        source:"qrc:/assets/homePage_background.jpg"
        fillMode: Image.PreserveAspectCrop

        asynchronous: true
        Rectangle
        {
            anchors.fill: parent
            color: Qt.rgba(0, 0, 0, 0.2)
        }
    }

    ColumnLayout
    {
        anchors.fill: parent
        spacing: 10

        Item
        {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 100
            anchors.margins: 30


            Rectangle
            {
                id: wheatherCard
                width: 150
                height: 120
                radius: 12

                color: Qt.rgba(0, 0, 0, 0);

                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter

                RowLayout
                {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 3

                    ColumnLayout
                    {
                        spacing: 4
                        Layout.fillWidth: true

                        Text
                        {
                            text: qsTr("Taipei") + languagemanager.emptyString
                            color: "#FFFFFF"
                            font.family: "Helvetica Neue, Roboto, sans-serif"
                            font.pixelSize: 15
                            font.bold: true
                        }

                        Text
                        {
                            text: weatherManager.temperature
                            color: "#FFFFFF"
                            font.family: "Helvetica Neue, Roboto, sans-serif"
                            font.pixelSize: 27
                            font.bold: true
                        }

                        Item
                        {
                            id: weatherConditioinTranslator

                            function getTranslatedCondition(condition)
                            {
                                switch(condition)
                                {
                                    case "Clouds": return qsTr("Clouds")
                                    case "Clear": return qsTr("Clear")
                                    case "Rain": return qsTr("Rain")
                                    case "Drizzle": return qsTr("Drizzle")
                                    case "Thunder": return qsTr("Thunder")
                                }
                            }
                        }

                        Text
                        {
                            text: weatherConditioinTranslator.getTranslatedCondition(weatherManager.condition) + languagemanager.emptyString
                            color: "#FFFFFF"
                            font.family: "Helvetica Neue, Roboto, sans-serif"
                            font.pixelSize: 13
                        }
                    }

                    Image
                    {
                        source: weatherManager.icon
                        sourceSize.width: 40
                        sourceSize.height: 40
                        Layout.alignment: Qt.AlignVCenter
                    }
                 }
            }

            Image
            {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/assets/Title.png"
                fillMode: Image.PreserveAspectFit
                height: 280
            }

            Image
            {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/assets/Logo.png"
                fillMode: Image.PreserveAspectFit
                height: 100
            }
        }

        ColumnLayout
        {
            Layout.alignment: Qt.AlignHCenter
            spacing: 8
            z: 10

            // -- DIGITAL CLOCK --
            Text
            {
                id: timeText
                text: "00:00"
                font.pixelSize: 92
                font.letterSpacing: -2.5
                font.weight: Font.ExtraLight
                font.family: "Helvetica Neue, Roboto, sans-serif"
                color: "#FFFFFF"
                Layout.alignment: Qt.AlignCenter
            }

            Text
            {
                id: dateText
                text: qsTr("MONDAY, JANUARY 1") + languagemanager.emptyString
                font.capitalization: Font.AllUppercase
                font.pixelSize: 20
                font.letterSpacing: 2
                color: "#FFFFFF"
                Layout.alignment: Qt.AlignHCenter
            }

            Timer
            {
                interval: 1000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered:
                {
                    var now = new Date();
                    timeText.text = Qt.formatDateTime(now, "hh:mm");
                    dateText.text = Qt.formatDateTime(now, "dddd, MMMM d");
                }
            }
        }

        // -- START BUTTON --
        Rectangle
        {
            id: startButton
            Layout.alignment: Qt.AlignHCenter
            width: 240
            height: 60
            radius: 30
            z:10

            color: startArea.containsPress ? "#55ffffff" : "#26ffffff"
            border.color: "#88E2B043"
            border.width: 1.5

            Text
            {
                text: qsTr("Touch to Begin") + languagemanager.emptyString
                color: "#FFFFFF"
                font.pixelSize: 23
                font.letterSpacing: -1.8
                font.weight: Font.bold
                font.family: "Helvetica Neue, Roboto, san-serif"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea
            {
                id: startArea
                anchors.fill: parent
                onClicked:
                {
                    stackView.replace("ControlPage.qml");
                }
            }
        }

        RowLayout
        {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Layout.fillWidth: true
            Layout.bottomMargin: 10

            Item
            {
                Layout.fillWidth: true
            }

            Item
            {
                id: languageSelector
                Layout.alignment: Qt.AlignRight
                Layout.rightMargin: 10
                Layout.preferredWidth: 122
                Layout.preferredHeight: 35

                Rectangle
                {
                    id: languagePopup
                    width: parent.width
                    height: langColumn.implicitHeight + 20

                    anchors.bottom: selectorBar.top
                    anchors.right: selectorBar.right
                    anchors.bottomMargin: 5

                    color: Qt.rgba(1, 1, 1, 0.4)
                    border.color: Qt.rgba(1, 1, 1, 0.78)
                    border.width: 1
                    radius: 8
                    visible: false

                    ColumnLayout
                    {
                        id: langColumn
                        anchors.fill: parent
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2

                        Rectangle
                        {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 22
                            radius: 8
                            color: opt1Area.containsMouse ? "#33FFFFFF" : "transparent"

                            Text
                            {
                                anchors.centerIn: parent
                                text: "English"
                                font.family: "Helvetica Neue, Roboto, san-serif"
                                color: Qt.rgba(0, 0, 0, 0.9)
                                font.pixelSize: 23
                            }

                            MouseArea
                            {
                                id: opt1Area
                                anchors.fill: parent
                                onClicked:
                                {
                                    languagemanager.selectLanguage("en")
                                    languagePopup.visible = false
                                }
                            }
                        }

                        Rectangle
                        {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 22
                            radius: 8
                            color: opt2Area.containsMouse ? "#33FFFFFF" : "transparent"

                            Text
                            {
                                anchors.centerIn: parent
                                text: "繁體中文"
                                color: Qt.rgba(0, 0, 0, 0.9)
                                font.pixelSize: 23
                            }

                            MouseArea
                            {
                                id: opt2Area
                                anchors.fill: parent
                                onClicked:
                                {
                                    languagemanager.selectLanguage("zh_TW")
                                    languagePopup.visible = false
                                }
                            }
                        }
                    }
                }

                Rectangle
                {
                    id: selectorBar
                    anchors.fill: parent
                    color: Qt.rgba(1, 1, 1, 0.26)
                    radius: 8
                    border.color: Qt.rgba(1, 1, 1, 0.6)
                    border.width: 1

                    RowLayout
                    {
                        anchors.centerIn: parent
                        spacing: 6

                        Image
                        {
                            id: selectorBarIcon
                        }

                        Text
                        {
                            id: currentLangText
                            text: languagemanager.currentLanguage
                            Layout.alignment: Qt.AlignVCenter
                            color: "#FFFFFF"
                            font.pixelSize: 23
                            font.weight: Font.Medium
                            font.letterSpacing: -1
                            font.family: "Helvetica Neue, Roboto, sans-serif"
                        }
                    }

                    MouseArea
                    {
                        id: barArea
                        anchors.fill: parent
                        onClicked:
                        {
                            languagePopup.visible = !languagePopup.visible
                        }
                    }
                }
            }
        }
    }
}
