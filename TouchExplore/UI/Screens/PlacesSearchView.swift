import SwiftUI
import UIKit
import MapKit
import Combine

struct PlacesSearchView<Content: View>: View {
	@ObservedObject private var viewModel:PlacesSearchViewModel
	
	private var onPlacesTapAction: (Landmark) -> Void = { landmark in
		print("on Landmark Click", landmark)
	}
	
	private var onEditingChanged: (Bool) -> Void = { _ in }
	
	private var emptyTermView: () -> Content
	
	init(
		viewModel: PlacesSearchViewModel,
		onPlacesTapAction: @escaping (Landmark) -> Void = { _ in },
		@ViewBuilder emptyTermView: @escaping () -> Content,
		onEditingChanged: ((Bool) -> Void)? = { _ in }
	) {
		self.viewModel = viewModel
		self.onPlacesTapAction = onPlacesTapAction
		
		self.emptyTermView = emptyTermView
	
		if let onEditingChanged = onEditingChanged {
			self.onEditingChanged = onEditingChanged
		}
	}
	
	var body: some View {
		VStack {
			SearchBar("Search for a city or place", text: self.$viewModel.term, onEditingChanged: self.onEditingChanged).style(UISearchBar.Style.minimal)

			if self.viewModel.term.count > 0 {
				PlacesListView(landmarks: self.viewModel.landmarks, onTapAction: self.onPlacesTapAction).accessibility(label: Text("Search results"))
			} else {
				emptyTermView()
			}
		}
	}
}

struct PlacesSearchView_Previews: PreviewProvider {
	static var previews: some View {
		PlacesSearchView(viewModel: PlacesSearchViewModel(), emptyTermView: {
			Text("No search text")
		}).environmentObject(MapViewModel())
	}
}
