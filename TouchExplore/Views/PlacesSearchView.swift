//
//  GeocoverView.swift
//  TactileMaps
//
//  Created by Dario Merz on 06.05.20.
//  Copyright © 2020 Dario Merz. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit

final class PlacesSearchStore: ObservableObject {
	@Published var term:String = "" {
		didSet {
			if term != oldValue {
				findPlaces(term)
			}
		}
	}
	
	@Published var landmarks:[Landmark] = []
	
	private func findPlaces(_ term: String) {
		guard term.count > 0 else {
			landmarks = []
			
			return
		}
		
		let request = MKLocalSearch.Request()
		request.naturalLanguageQuery = self.term
		
		let search = MKLocalSearch(request: request)
		search.start { (response, error) in
			guard let response = response, error == nil else { return }

			let mapItems = response.mapItems

			self.landmarks = mapItems.map {
				Landmark(placemark: $0.placemark)
			}
		}
//
//		let geocoder = CLGeocoder()
//		geocoder.geocodeAddressString(self.term, completionHandler: { (landmarks, error) in
//			print(landmarks)
////
////			self.landmarks = landmarks.map {
////				Landmark(placemark: $0)
////				}
//		})
		
//		let geocoder = CLGeocoder()
//		geocoder.geocode
	}
}

struct PlacesSearchView: View {
	@ObservedObject var state = PlacesSearchStore()

	
	var body: some View {
		VStack {
			SearchBar("Nach einem Ort oder einer Adresse suchen", text: self.$state.term).style(UISearchBar.Style.minimal)
			PlacesListView(landmarks: self.state.landmarks).resignKeyboardOnDragGesture()
		}
    }
}

struct PlacesSearchView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesSearchView()
    }
}
