import SwiftUI
import UIKit
import MapKit
import Combine

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
