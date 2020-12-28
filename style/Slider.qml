import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtGraphicalEffects 1.15

T.Slider {
    id: control

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        implicitWidth: control.availableWidth
        implicitHeight: 8
        radius: 4
        color: "#555555"

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            radius: parent.radius
            color: "#FF4043"
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + (control.availableHeight - height) / 2
        implicitWidth: 20
        implicitHeight: 20
        radius: 10
        color: control.pressed ? "#FFFFFF" : hoverHandler.hovered ? "#D0D0D0" : "#A0A0A0"
        layer.enabled: true
        layer.effect: DropShadow {
            radius: 6
            samples: 13
            spread: 0.3
            color: control.pressed ? "#FFFFFF" : hoverHandler.hovered ? "#D0D0D0" : "#A0A0A0"
        }

        HoverHandler {
            id: hoverHandler
        }
    }
}
