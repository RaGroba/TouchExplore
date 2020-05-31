import SwiftUIFlux
import Mapbox

struct AppState: FluxState {
	var mapState: MapState
//	var featureInteractionState: FeatureInteractionState
	
	init() {
		mapState = MapState()
//		featureInteractionState = FeatureInteractionState()
	}
}
