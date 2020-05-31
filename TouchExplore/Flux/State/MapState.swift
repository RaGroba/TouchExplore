import SwiftUIFlux
import Mapbox

struct MapState: FluxState {
	private static let ZURICH_COORDINATES: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 47.3686498, longitude: 8.5391825) // Zurich
	
	var features: [MGLFeature] = [MGLFeature]()
	var zoomLevel: Double = 18
	var centerCoordinate: CLLocationCoordinate2D = ZURICH_COORDINATES
}
