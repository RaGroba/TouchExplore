import SwiftUI
import Mapbox
import AVKit
import UIKit

struct ContentView: View {
	@EnvironmentObject var env: MapStore
	@ObservedObject var placesSearchViewModel: PlacesSearchViewModel = PlacesSearchViewModel()
	@ObservedObject var disabilitySimulatorViewModel: DisabilitySimulatorViewModel = DisabilitySimulatorViewModel()
	
	@State var isMapInteractive:Bool = false
	@State var isSettingsOpen = false
	
	let locationManager = CLLocationManager()
	
	@State var isDisabilitySimulatorPresented: Bool = false
	
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				Group {
					Group {
						MapView(locationManager: self.locationManager, zoomLevel: self.$env.zoomLevel, features: self.$env.features, centerCoordinate: self.$env.centerCoordinate).edgesIgnoringSafeArea(.all)
					}.accessibility(hidden: !self.isMapInteractive)
						.accessibilityElement(children: .combine)
						.accessibility(addTraits: .allowsDirectInteraction)
						.disabilitySimulator(vm: self.disabilitySimulatorViewModel)
				}
				
				// Map Controls
				VStack {
					HStack {
						Spacer()
						VStack {
							Button(action: {
								self.isDisabilitySimulatorPresented = true
							}) {
								Image(systemName: "wrench")
									.modifier(MapButton())
									.accessibility(label: Text("Disability Simulator"))
							}.sheet(isPresented: self.$isDisabilitySimulatorPresented) {
								NavigationView {
									VStack {
										DisabilitySimulatorView(vm: self.disabilitySimulatorViewModel)
									}.navigationBarTitle(Text("Disability Simulator"), displayMode: .inline).navigationBarItems(
										leading: Button(action: {
											self.isDisabilitySimulatorPresented = false
										}) {
											Text("Abbrechen")
										},
										trailing: Button(action: {
											self.isDisabilitySimulatorPresented = false
										}) {
											Text("Speichern").fontWeight(.semibold)
										}
									)
								}
							}
							Button(action: {
								self.env.centerCoordinate = self.locationManager.location?.coordinate as! CLLocationCoordinate2D
							}) {
								Image(systemName: "location.fill")
									.modifier(MapButton())
									.accessibility(label: Text("Aktueller Standort einblenden"))
							}
						}.padding(.trailing, 8)
					}
					Spacer()
				}
				
				// Search Sheet
				BottomSheetView(isOpen: self.$isSettingsOpen, maxHeight: geometry.size.height * 0.93) {
					VStack {
						PlacesSearchView(viewModel: self.placesSearchViewModel)
					}
				}.accessibilityElement(children: .contain).edgesIgnoringSafeArea(.all)
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView().environmentObject(MapStore())
	}
}

fileprivate struct MapButton: ViewModifier {
	
	let backgroundColor: Color = Color(UIColor.systemGroupedBackground)
	var fontColor: Color = Color.white
	
	func body(content: Content) -> some View {
		content
			.padding()
			.background(self.backgroundColor.opacity(0.9))
			.foregroundColor(self.fontColor)
			.clipShape(Circle())
			.shadow(radius: 8)
	}
	
}
