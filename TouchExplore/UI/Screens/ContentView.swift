import SwiftUI
import Mapbox
import AVKit
import UIKit

struct ContentView: View {
	@EnvironmentObject var router: ViewRouter
	
	@ObservedObject var viewModel: MapViewModel
	
	@ObservedObject var disabilitySimulatorViewModel: DisabilitySimulatorViewModel = DisabilitySimulatorViewModel()
	@ObservedObject var featureInteractionViewModel: FeatureInteractionViewModel = FeatureInteractionViewModel()
	@ObservedObject var placesSearchViewModel: PlacesSearchViewModel = PlacesSearchViewModel()
	
	let locationManager = CLLocationManager()
	
	@State var isSettingsOpen = false
	@State var isDisabilitySimulatorPresented: Bool = false
	
	@State var isMapActive = false
	
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				AccessibilityModalView(isActive: self.$isMapActive) {
					MapView(locationManager: self.locationManager, zoomLevel: self.$viewModel.map.zoomLevel, features: self.$viewModel.map.interactedFeatures, centerCoordinate: self.$viewModel.map.centerCoordinate, onRequestBlur: {
							self.isMapActive = false
						})
						.edgesIgnoringSafeArea(.all)
						.accessibilityElement(children: .combine)
						.disabilitySimulator(values: self.viewModel.disabilities)
						
				}
				
				VStack {
					HStack {
						Spacer()
						VStack {
							Button(action: {
								self.isDisabilitySimulatorPresented = true
							}) {
								Image(systemName: "bandage.fill")
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
											self.viewModel.disabilities = self.disabilitySimulatorViewModel.disabilities
										}) {
											Text("Speichern").fontWeight(.semibold)
										}
									)
								}
							}
							Button(action: {
								self.viewModel.map.centerCoordinate = self.locationManager.location?.coordinate as! CLLocationCoordinate2D
							}) {
								Image(systemName: "location.fill")
									.modifier(MapButton())
									.accessibility(label: Text("Aktueller Standort einblenden"))
							}
							Button(action: {
								self.router.goto(Routes.IntroView)
							}) {
								Image(systemName: "info.circle")
									.modifier(MapButton())
									.accessibility(label: Text("Intro erneut anzeigen"))
							}
						}.padding(.trailing, 8)
					}
					Spacer()
				}
				
				MapControlSheet(viewModel: self.viewModel, placesSearchViewModel: self.placesSearchViewModel, isPresented: self.$isSettingsOpen, maxHeight: Double(geometry.size.height) * 0.93)
			}
		}
	}
}


fileprivate struct MapButton: ViewModifier {
	let backgroundColor: Color = Color(UIColor.systemGroupedBackground)
	var fontColor: Color = Color.primary
	
	func body(content: Content) -> some View {
		content
			.padding()
			.background(self.backgroundColor.opacity(0.9))
			.foregroundColor(self.fontColor)
			.clipShape(Circle())
			.shadow(radius: 8)
	}
	
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(viewModel: MapViewModel()).environmentObject(MapViewModel())
	}
}
