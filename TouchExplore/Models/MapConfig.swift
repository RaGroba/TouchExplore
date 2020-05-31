import Mapbox

struct Map {
	var zoomLevel: Double = 18
	var centerCoordinates: CLLocationCoordinate2D = Places.Zurich
}

extension Map {
	private struct Places {
		static let Zurich: CLLocationCoordinate2D =  CLLocationCoordinate2D(latitude: 47.3686498, longitude: 8.5391825)
	}
}
