import SwiftUI
import Mapbox
import AVKit

struct ContentView: View {
	@State var state: MapStore = MapStore()
	
	@State var locationManager = CLLocationManager()
	
	@State var input:String = ""
	@State var isSettingsOpen = false
	
	var mapView: MapView!
	
	init() {
		// somehow we have to use mapView via a var, otherwise visibleFeatures(at) would always return an empty array
		self.mapView = MapView(locationManager: $locationManager, zoom: self.$state.zoomLevel, features: self.$state.features)
	}
	
    var body: some View {
		GeometryReader { geometry in
			ZStack {
				Group {
					self.mapView.zoomLevel(self.state.zoomLevel).edgesIgnoringSafeArea(.all)
				}.accessibility(hidden: true)
				BottomSheetView(isOpen: self.$isSettingsOpen, maxHeight: geometry.size.height * 0.93) {
					PlacesSearchView()
				}.accessibilityElement(children: .contain)
			}
		}.edgesIgnoringSafeArea(.all)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		ContentView()
			
    }
}

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}
