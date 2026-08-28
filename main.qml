import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.VirtualKeyboard 2.1

ApplicationWindow {
    id: window
    visible: true
    visibility: window.FullScreen
    width: 800
    height: 480
    title: "Application_Proj_1_1"

    Component.onCompleted:
    {}

    StackView
    {
        id:stackView
        anchors.fill:parent
        initialItem: "HomePage.qml"
    }

    InputPanel
    {
        id: inputPanel
        z: 99
        x:0
        y: window.height
        width: window.width * 0.7
        anchors.horizontalCenter: parent.horizontalCenter

        states: State
        {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: window.height - inputPanel.height
            }
        }

        transitions: Transition
        {
            from: ""
            to: "visible"
            reversible: true
            NumberAnimation { duration: 250; easing.type: Easing.InOutQuad }
        }
    }
}
