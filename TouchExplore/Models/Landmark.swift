import Foundation
import MapKit
import CoreLocation

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
		
	var coordinate: CLLocationCoordinate2D {
		return self.placemark.location!.coordinate
	}
	
	var locality: String? {
		return self.placemark.locality;
	}
}
