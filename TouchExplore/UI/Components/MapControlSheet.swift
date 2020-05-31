import SwiftUI

struct MapControlSheet: View {
	@ObservedObject var viewModel: MapViewModel
	@ObservedObject var placesSearchViewModel: PlacesSearchViewModel = PlacesSearchViewModel()
	
	@Binding var isPresented: Bool
	@State var maxHeight: Double
		
	var body: some View {
		// Search Sheet
		BottomSheetView(isOpen: self.$isPresented, maxHeight: CGFloat(maxHeight)) {
			VStack {
				PlacesSearchView(viewModel: self.placesSearchViewModel, onPlacesTapAction: { landmark in
					self.viewModel.map.centerCoordinate = landmark.coordinate
				}, emptyTermView: {
					TestScenarioSelection(onSelect: { setup in
						self.viewModel.map = setup.mapConfig
						self.viewModel.disabilities = setup.disabilities
					})
				})
			}
		}.accessibilityElement(children: .contain).edgesIgnoringSafeArea(.all)
	}
}
