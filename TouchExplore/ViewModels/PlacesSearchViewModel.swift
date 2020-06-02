import SwiftUI
import UIKit
import MapKit
import Combine

class PlacesSearchViewModel: ObservableObject, Identifiable {
	private let searchPlacesService: SearchPlacesService = MapKitSearchPlaces()

	private static let searchDistance = CLLocationDistance(10_000)
	
	@Published var term: String = ""
	@Published var landmarks:[Landmark] = []
	
	private let region: MKCoordinateRegion = MKCoordinateRegion(center: Locations.Zurich, latitudinalMeters: PlacesSearchViewModel.searchDistance, longitudinalMeters: PlacesSearchViewModel.searchDistance)
	
	private var searchCancellable: Cancellable? {
		didSet {
			oldValue?.cancel()
		}
	}
	
	deinit {
		searchCancellable?.cancel()
	}
	
	init() {
		searchCancellable = $term
			.debounce(for: 0.2, scheduler: DispatchQueue.main)
			.removeDuplicates()
			.filter { !$0.isEmpty && $0 != "" }
			.setFailureType(to: Error.self)
			.flatMap { searchString -> AnyPublisher<[Landmark], Error> in
				print("searchString: \(searchString)")

				return self.searchPlacesService.query(term: searchString, region: self.region)
			}
			.replaceError(with: [])
			.receive(on: RunLoop.main)
			.assign(to: \.landmarks, on: self)
	}
	
		
		//		let geocoder = CLGeocoder()
		//		let region = CLCircularRegion(center: Locations.Zurich, radius: CLLocationDistance(5000), identifier: "search-region")
		//
		//		geocoder.geocodeAddressString(self.term, in: region, completionHandler: { (response, error) in
		//			guard let response = response, error == nil else { return }
		//
		//			if response.count > 0 {
		//				print("Geocoder: Found:", response)
		//				self.landmarks = response.map {
		//					Landmark(placemark: $0)
		//				}
		//			} else {
		//				self.landmarks = []
		//			}
		//		})
}
