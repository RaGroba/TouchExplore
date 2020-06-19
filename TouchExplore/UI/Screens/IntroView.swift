import SwiftUI
import UIKit

struct IntroView: View {
	var appName : String {
		(Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? "Touch Explore"
	}

	var version : String? {
		Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
	}
	
    @EnvironmentObject var router: ViewRouter
	
	let gestures: [String] = [
		"Explore: move one finger on screen",
		"Two-finger swipe: move map by one screen width",
		"Double tap: center map on the tapped location",
		"Pinch: change zoom level"
	]
	
    var body: some View {
		VStack {
			Group {
				VStack {
					Spacer()
					Text(appName).font(.largeTitle).fontWeight(.bold).padding(.bottom)
					if version != nil {
						Text("Version: \(version ?? "")")
							.font(.footnote)
							.foregroundColor(Color.secondary)
					}
					Spacer()
				}
				
				VStack (alignment: .leading, spacing: 8) {
					Text("Instructions").font(.headline).multilineTextAlignment(.center).padding(.bottom)
					Text("Welcome on \(appName). With TouchExplore you can explore the map audiotactilly. To do so activate the map with a double tap and then move a finger on the screen. You will then hear sounds and get a haptic feedback based on the object you're interacting with. To switch back to VoiceOver mode (exit the map), swipe up with three fingers. You can use the following gestures to navigate on the map:")
						.multilineTextAlignment(.leading)
						.fixedSize(horizontal: false, vertical: true)
						.lineLimit(nil)
					VStack(alignment: .leading, spacing: 8) {
						ForEach(gestures, id: \.self) { text in
							HStack(alignment: .top, spacing: 20) {
								Text("\u{2022}")
									.accessibility(hidden: true)
								Text(text)
									.multilineTextAlignment(.leading)
									.lineLimit(nil)
									.fixedSize(horizontal: false, vertical: true)
							}.accessibilityElement(children: .combine)
						}
					}.padding(.top, 16)
					Spacer()
				}
			}.padding()
			Spacer()
			Group {
				Button(action: {
					self.router.currentPage = Routes.ContentView
				}) {
					Text("Start")
						.frame(minWidth: 100, maxWidth: .infinity, alignment: .center)
				}
				.padding(.all)
				.foregroundColor(.white)
				.background(Color.blue)
				.cornerRadius(8)
			}.padding()
		}
	}
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
		IntroView().environmentObject(ViewRouter())
    }
}
