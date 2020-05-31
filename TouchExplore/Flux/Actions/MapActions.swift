import SwiftUIFlux
import Mapbox

struct MapActions {
	struct ChangeFeatures: Action {
		let features: [MGLFeature]
	}
	
	struct SetZoomLevel: Action {
		let zoomLevel: Double
	}
	
	struct ZoomIn: Action {
	}
	
	struct ZoomOut: Action {
	}
}


