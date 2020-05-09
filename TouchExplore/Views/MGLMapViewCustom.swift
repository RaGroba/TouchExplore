import Foundation
import Mapbox

class MGLMapViewCustom:MGLMapView {

	override var accessibilityLabel: String? {
        get {
            return "Karte"
        }
        set {}
	}

	override var accessibilityValue: String? {
        get {
            return ""
        }
        set {}
	}
}

