/****************************************************************************
*
* (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
*
* QGroundControl is licensed according to the terms in the file
* COPYING.md in the root of the source code directory.
*
* ***************************************************************************/


import QtQuick                      2.3
import QtQuick.Controls             1.2
import QtQuick.Controls.Styles      1.4
import QtQuick.Controls.Private     1.0

import QGroundControl               1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controllers   1.0

Slider {
    FactPanelController {
        id: controller
    }
    
    id:             _root
    implicitHeight: ScreenTools.implicitSliderHeight
    value:          0
    minimumValue:   minimum
    maximumValue:   maximum
    stepSize:       0.01
    enabled:        false
    visible:        false
    onValueChanged: {
        controller.setParameterFact(-1, "RC_YAW_OFF", value)
    }

    // Get active flight mode
    property var currentVehicle: QGroundControl.multiVehicleManager.activeVehicle
    
    // Value indicator starts display from zero instead of min value
    property bool zeroCentered: true
    property bool displayValue: true
    property real maximum:      if (controller.getParameterFact(-1, "COM_RC_YAW_OFF", false) === null)
                                    60
                                else
                                    controller.getParameterFact(-1, "COM_RC_YAW_OFF", false).value
    property real minimum:      (maximum) * -1
    
//    Component.onCompleted: {
//        console.debug("The value of controller.getParameterFact = " + controller.getParameterFact(-1, "COM_RC_YAW_OFF", false));
//        console.debug("The value of controller.setParameterFact = " + controller.setParameterFact(-1, "RC_YAW_OFF", value));
//        console.debug("the value of real maximum = " + maximum);
//        console.debug("the value of real minimum = " + minimum);
//        console.debug("the value of onValueChanged = " + onValueChanged);
//    }

    style: SliderStyle {
        groove: Item {
            anchors.verticalCenter: parent.verticalCenter
            implicitWidth:          Math.round(ScreenTools.defaultFontPixelHeight * 4.5)
            implicitHeight:         Math.round(ScreenTools.defaultFontPixelHeight * 0.3)

            Rectangle {
                radius:         height / 2
                anchors.fill:   parent
                color:          qgcPal.button
                border.width:   1
                border.color:   qgcPal.buttonText
            }
        }

        handle: Rectangle {
            anchors.centerIn:   parent
            color:              qgcPal.button
            border.color:       qgcPal.buttonText
            border.width:       1
            implicitWidth:      _radius * 2
            implicitHeight:     _radius * 2
            radius:             _radius

            property real _radius: Math.round(_root.implicitHeight / 2)

            Rectangle {
                color:                      qgcPal.button
                border.color:               qgcPal.buttonText
                implicitWidth:              _radius * 6
                implicitHeight:             _radius * 2.3
                anchors.bottom:             parent.top
                anchors.horizontalCenter:   parent.horizontalCenter
            }

            Label {
                property real degrees:      value
                text:                       degrees.toFixed(2)
                visible:                    _root.displayValue
                anchors.bottom:             parent.top
                anchors.horizontalCenter:   parent.horizontalCenter
                font.family:                ScreenTools.normalFontFamily
                font.pointSize:             ScreenTools.mediumFontPointSize
            }
        }
    }
}
