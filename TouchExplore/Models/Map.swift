import Mapbox

struct Map {
	var zoomLevel: Double
	var centerCoordinate: CLLocationCoordinate2D
	var interactedFeatures: [MGLFeature] = []
	
	init(zoomLevel: Double = 18, centerCoordinate: CLLocationCoordinate2D = Locations.Zurich) {
		self.zoomLevel = zoomLevel
		self.centerCoordinate = centerCoordinate
	}
}

