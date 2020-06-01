import Combine
import MapKit

protocol SearchPlacesService {
	func query(term: String, region: MKCoordinateRegion?) -> AnyPublisher<[Landmark], Error>
}

class MapKitSearchPlaces: SearchPlacesService {
	private var search: MKLocalSearch?
	
	func query(term: String, region: MKCoordinateRegion? = nil) -> AnyPublisher<[Landmark], Error> {
		Future { promise in
			let request = MKLocalSearch.Request()
			
			request.naturalLanguageQuery = term
			
			if let region = region {
				request.region = region
			}
			
			if let search = self.search {
				search.cancel()
			}
			
			self.search = MKLocalSearch(request: request)
			self.search?.start { (response, error) in
				guard let response = response else {
					if let error = error {
						promise(.failure(error))
					}
					return
				}
				
				let mapItems = response.mapItems.filter({ $0.timeZone != nil }).map {
					Landmark(placemark: $0.placemark)
				}
				
				promise(.success(mapItems))
			}
		}
		.handleEvents(receiveCancel: {
			self.search?.cancel()
		})
		.eraseToAnyPublisher()
	}
}
