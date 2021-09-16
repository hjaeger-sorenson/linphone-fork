pragma Singleton
import QtQml 2.2

import Units 1.0
import ColorsList 1.0

// =============================================================================

QtObject {
	property string sectionName: 'ActivateApp'
	property int spacing: 20
	
	property QtObject activationSteps: QtObject {
		property color color: ColorsList.add(sectionName+'_phone_steps', 'g').color
		property int pointSize: Units.dp * 10
	}
}
