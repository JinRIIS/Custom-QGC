/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick 2.3

import QGroundControl                  1.0
import QGroundControl.ScreenTools      1.0
import QGroundControl.Controls         1.0
import QGroundControl.Palette          1.0
import QGroundControl.Vehicle          1.0
import QGroundControl.Controllers      1.0
import QGroundControl.FactSystem       1.0
import QGroundControl.FactControls     1.0

Item {
    // The following properties must be passed in from the Loader
    // property bool autoCenterThrottle - true: throttle will snap back to center when released

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    
    FactPanelController {
        id: controller
    }

    Timer {
        interval:   40  // 25Hz, same as real joystick rate
        running:    QGroundControl.settingsManager.appSettings.virtualJoystick.value && _activeVehicle
        repeat:     true
        onTriggered: {
            if (_activeVehicle && (_activeVehicle.flightMode === "Orbit" || _activeVehicle.flightMode === "Mission")) {
                _activeVehicle.virtualTabletJoystickValue(rightStick.xAxis, rightStick.yAxis, 0, pitchSlider.value)
            }else if (_activeVehicle) {
                _activeVehicle.virtualTabletJoystickValue(rightStick.xAxis, rightStick.yAxis, leftStick.xAxis, leftStick.yAxis)
                controller.setParameterFact(-1, "RC_YAW_OFF", 0)
                yawSlider.value = 0
            } else {
                controller.setParameterFact(-1, "RC_YAW_OFF", 0)
                yawSlider.value = 0
            }
        }
    }
    
    QGCVerticalSlider {
        id:                 pitchSlider
        enabled:            _activeVehicle && (_activeVehicle.flightMode === "Orbit" || _activeVehicle.flightMode === "Mission")
        visible:            _activeVehicle && (_activeVehicle.flightMode === "Orbit" || _activeVehicle.flightMode === "Mission")
        anchors.left:       parent.left
        anchors.bottom:     parent.bottom
        height:             parent.height
        width:              parent.height/2
    }
    
    QGCHorizontalSlider {
        id:                     yawSlider
        enabled:                _activeVehicle && (_activeVehicle.flightMode === "Orbit" || _activeVehicle.flightMode === "Mission")
        visible:                _activeVehicle && (_activeVehicle.flightMode === "Orbit" || _activeVehicle.flightMode === "Mission")
        anchors.left:           pitchSlider.right
        anchors.leftMargin:     20
        width:                  parent.height
        height:                 parent.height/2
        value:                  0
        
        QGCButton {
            id:                         resetZero
            enabled:                    _activeVehicle && (_activeVehicle.flightMode === "Orbit" || _activeVehicle.flightMode === "Mission")
            visible:                    _activeVehicle && (_activeVehicle.flightMode === "Orbit" || _activeVehicle.flightMode === "Mission")
            anchors.top:                yawSlider.bottom
            anchors.horizontalCenter:   yawSlider.horizontalCenter
            height:                     parent.height/2
            text:                       "Reset to 0"
            onClicked: {
                                        yawSlider.value = 0
            }
        }
    }

    JoystickThumbPad {
        id:                     leftStick
        enabled:                !(_activeVehicle && (_activeVehicle.flightMode === "Orbit" || _activeVehicle.flightMode === "Mission"))
        visible:                !(_activeVehicle && (_activeVehicle.flightMode === "Orbit" || _activeVehicle.flightMode === "Mission"))    
        anchors.leftMargin:     xPositionDelta
        anchors.bottomMargin:   -yPositionDelta
        anchors.left:           parent.left
        anchors.bottom:         parent.bottom
        width:                  parent.height
        height:                 parent.height
        yAxisPositiveRangeOnly: _activeVehicle && !_activeVehicle.rover
        yAxisReCenter:          autoCenterThrottle
    }

    JoystickThumbPad {
        id:                     rightStick
        anchors.rightMargin:    -xPositionDelta
        anchors.bottomMargin:   -yPositionDelta
        anchors.right:          parent.right
        anchors.bottom:         parent.bottom
        width:                  parent.height
        height:                 parent.height
    }
}
