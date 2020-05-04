import Foundation
import Mapbox

class MGLMapViewCustom:MGLMapView {
		
	// disable default accessibility props (TODO: re-enable them later on once we've implemented our custom logic
	override var accessibilityLabel: String? {
        get {
            return ""
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

