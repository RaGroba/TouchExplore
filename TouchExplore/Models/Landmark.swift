import Foundation
import MapKit

struct Landmark: Identifiable {
	let placemark: MKPlacemark

	var id: UUID {
		return UUID()
	}
	
	var name: String {
		return self.placemark.name ?? ""
	}
	
	var country: String? {
		return self.placemark.country
	}
	
	var title: String {
		return self.placemark.title ?? ""
	}
	
	var coordinate: CLLocationCoordinate2D {
		return self.placemark.coordinate
	}
	
	var locality: String? {
		return self.placemark.locality;
	}
}
