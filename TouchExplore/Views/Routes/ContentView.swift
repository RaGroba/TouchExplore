import SwiftUI
import Mapbox
import AVKit

struct ContentView: View {
	@EnvironmentObject var env: MapStore
	@ObservedObject var placesSearchViewModel: PlacesSearchViewModel = PlacesSearchViewModel()
	@State var isSettingsOpen = false
	
	@EnvironmentObject var setting: Settings
	
	let locationManager = CLLocationManager()
	
    var body: some View {
		GeometryReader { geometry in
			ZStack {
				Group {
					MapView(locationManager: self.locationManager, zoomLevel: self.$env.zoomLevel, features: self.$env.features, centerCoordinate: self.$env.centerCoordinate).edgesIgnoringSafeArea(.all)
				}.accessibility(hidden: true)
				BottomSheetView(isOpen: self.$isSettingsOpen, maxHeight: geometry.size.height * 0.93) {
					VStack {
						PlacesSearchView(viewModel: self.placesSearchViewModel)
						DisabilitySimulatorConfigView()
					}
				}.accessibilityElement(children: .contain)

				VStack {
					HStack {
						Spacer()
						Button(action: { }) {
							Image(systemName: "wrench")
								.modifier(MapButton(backgroundColor: .primary))
								.accessibility(label: Text("Einstellungen"))
						}
						.padding(.trailing)
					}
					.padding(.top)
					Spacer()
				}
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

fileprivate struct MapButton: ViewModifier {

    let backgroundColor: Color
    var fontColor: Color = Color(UIColor.systemBackground)

    func body(content: Content) -> some View {
        content
            .padding()
            .background(self.backgroundColor.opacity(0.9))
            .foregroundColor(self.fontColor)
            .clipShape(Circle())
    }

}
