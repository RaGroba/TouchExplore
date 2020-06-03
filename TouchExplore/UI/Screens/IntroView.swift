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
		"Explorieren: Einen Finger auf dem Screen bewegen.",
		"Zwei Finger Swipe: Kartenausschnitt um volle Bildschirmbreite wechseln",
		"Doubletap: Kartenmittelpunkt setzen",
		"Pinch und Swipe: Zoomlevel ändern"
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
					Text("Anleitung").font(.headline).multilineTextAlignment(.center).padding(.bottom)
					Text("Willkommen! \(appName) bietet Ihnen die Möglichkeit, eine Karte audiotaktil zu erleben. Aktivieren Sie dazu nach dem Klick auf Start die Karte mit einem doppelklick und bewegen Sie anschliessend einen Finger auf der Karte. Um zurück inden VoiceOver Modus zu wechseln, mit drei Fingern nach oben streichen. Zur Navigation auf der Karte stehen ihnen folgende Gesten zur Verfügung:")
					VStack(alignment: .leading, spacing: 8) {
						ForEach(gestures, id: \.self) { text in
							HStack(spacing: 20) {
								Text("\u{2022}").accessibility(hidden: true)
								Text(text)
							}.accessibilityElement(children: .combine)
						}
					}
					Spacer()
				}
			}.padding()
			Spacer()
			Group {
				Button(action: {
					self.router.currentPage = Routes.ContentView
				}) {
					Text("Starten")
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
        IntroView()
    }
}
