import SwiftUI
import UIKit
import MapKit
import Combine

class PlacesSearchViewModel: ObservableObject, Identifiable {	
	@Published var term = "" {
		didSet {
			print("new term", term)
			if (term != oldValue) {
				findPlaces(term)
			}
		}
	}
	
	@Published var landmarks:[Landmark] = []
	
	private var searchCancellable: Cancellable? {
		didSet {
			oldValue?.cancel()
		}
	}
	
	deinit {
		searchCancellable?.cancel()
	}
	
	init() {
//		searchCancellable = $term
//			.debounce(for: 0.5, scheduler: DispatchQueue.main)
//			.removeDuplicates()
//			.filter { !$0.isEmpty && $0.first != " " }

//		            .flatMap { (searchString) -> AnyPublisher<[Landmark], Never> in
//		                print("searchString: \(searchString)")
//
//		                return findPlaces(searchString)
//		            }
//		            .map {
//		                self.booksToBookDisplayData(books: $0)
//		            }
//		            .replaceError(with: []) //TODO: Handle Errors
//		            .assign(to: \.items, on: self)
	}
	
	func findPlaces(_ term: String) {
		guard term.count > 0 else {
			landmarks = []
			return
		}
		
//		let request = MKLocalSearchCompleter()
//		request.queryFragment = term

		let request = MKLocalSearch.Request()
		request.naturalLanguageQuery = term
		request.region = MKCoordinateRegion(center: Locations.Zurich, latitudinalMeters: CLLocationDistance(10_000), longitudinalMeters: CLLocationDistance(10_000))
	
		let search = MKLocalSearch(request: request)
		search.start { (response, error) in
			guard let response = response, error == nil else { return }

			let mapItems = response.mapItems

			self.landmarks = mapItems.map {
				Landmark(placemark: $0.placemark)
			}
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
}

struct PlacesSearchView<Content: View>: View {
	@ObservedObject private var viewModel:PlacesSearchViewModel
	
	private var onPlacesTapAction: (Landmark) -> Void = { landmark in
		print("on Landmark Click", landmark)
	}
	
	private var emptyTermView: () -> Content
	
	init(viewModel: PlacesSearchViewModel, onPlacesTapAction: @escaping (Landmark) -> Void = { _ in }, @ViewBuilder emptyTermView: @escaping () -> Content) {
		self.viewModel = viewModel
		self.onPlacesTapAction = onPlacesTapAction
		
		self.emptyTermView = emptyTermView
	}
	
	var body: some View {
		VStack {
			SearchBar("Nach einem Ort oder einer Adresse suchen", text: self.$viewModel.term).style(UISearchBar.Style.minimal)
			
			if self.viewModel.term.count > 0 {
				PlacesListView(landmarks: self.viewModel.landmarks, onTapAction: self.onPlacesTapAction).resignKeyboardOnDragGesture().accessibility(label: Text("Suchresultate"))
			} else {
				emptyTermView()
			}
		}
	}
}

struct PlacesSearchView_Previews: PreviewProvider {
	static var previews: some View {
		PlacesSearchView(viewModel: PlacesSearchViewModel(), emptyTermView: {
			Text("Ihr Suchbegriff ist leer")
		}).environmentObject(MapViewModel())
	}
}
