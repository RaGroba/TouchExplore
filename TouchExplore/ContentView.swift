import SwiftUI
import Mapbox
import AVKit

struct ContentView: View {
	@EnvironmentObject var env: MapStore
	@ObservedObject var placesSearchViewModel: PlacesSearchViewModel = PlacesSearchViewModel()
	@State var isSettingsOpen = false
	
	let locationManager = CLLocationManager()
	
    var body: some View {
		GeometryReader { geometry in
			ZStack {
				Group {
					MapView(locationManager: self.locationManager, zoomLevel: self.$env.zoomLevel, features: self.$env.features, centerCoordinate: self.$env.centerCoordinate).edgesIgnoringSafeArea(.all)
				}.accessibility(hidden: true)
				BottomSheetView(isOpen: self.$isSettingsOpen, maxHeight: geometry.size.height * 0.93) {
					PlacesSearchView(viewModel: self.placesSearchViewModel)
				}.accessibilityElement(children: .contain)
			}
		}.edgesIgnoringSafeArea(.all)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView().environmentObject(MapStore())
    }
}

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}
