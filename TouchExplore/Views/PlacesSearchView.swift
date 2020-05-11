import SwiftUI
import UIKit
import MapKit
import Combine

class PlacesSearchViewModel: ObservableObject, Identifiable {	
	@Published var term = "" {
		didSet {
			if (term != oldValue) {
				findPlaces(term)
			}
		}
	}
	
	@Published var landmarks:[Landmark] = []

	func findPlaces(_ term: String) {
		guard term.count > 0 else {
			landmarks = []
			return
		}
		
//		let request = MKLocalSearch.Request()
//		request.naturalLanguageQuery = term
//
//		let search = MKLocalSearch(request: request)
//		search.start { (response, error) in
//			guard let response = response, error == nil else { return }
//
//			let mapItems = response.mapItems
//
//			self.landmarks = mapItems.map {
//				Landmark(placemark: $0.placemark)
//			}
//		}
		
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(self.term, completionHandler: { (response, error) in
			guard let response = response, error == nil else { return }
			
			print("Geocoder: Found:", response)
			self.landmarks = response.map {
				Landmark(placemark: $0)
			}
		})
	}
}

struct PlacesSearchView: View {
	@EnvironmentObject var mapState: MapStore
	
	@ObservedObject var viewModel:PlacesSearchViewModel
	
	var body: some View {
		VStack {
			SearchBar("Nach einem Ort oder einer Adresse suchen", text: self.$viewModel.term).style(UISearchBar.Style.minimal)
			PlacesListView(landmarks: self.viewModel.landmarks, onTapAction: { landmark in
				print("Click on Landmark", landmark)
				
				self.mapState.centerCoordinate = landmark.coordinate
			}).resignKeyboardOnDragGesture()
		}
    }
}

struct PlacesSearchView_Previews: PreviewProvider {
    static var previews: some View {
		PlacesSearchView(viewModel: PlacesSearchViewModel()).environmentObject(MapStore())
    }
}
