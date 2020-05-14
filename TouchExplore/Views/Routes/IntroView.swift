import SwiftUI
import UIKit

struct IntroView: View {
	var appName : String {
		(Bundle.main.infoDictionary?["CFBundleName"] as? String) ?? "Touch Explore"
	}

	var version : String? {
		Bundle.main.infoDictionary?["CFBundleVersion"] as? String
	}
	
    @EnvironmentObject var router: ViewRouter
	
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
				
				VStack (alignment: .leading) {
					Text("Anleitung").font(.headline).multilineTextAlignment(.center).padding(.bottom)
					Text("Willkommen! \(appName) bietet Ihnen die Möglichkeit, eine Karte audiotaktil zu erleben. Aktivieren Sie dazu nach dem Klick auf Start die Karte und bewegen Sie anschliessend einen Finger auf der Karte. Hier kommt der Rest der Anleitung...")
					Spacer()
				}
			}.padding()
			Spacer()
			Group {
				Button(action: {
					self.router.currentPage = Routes.ContentView
				}) {
					Text("Starten")
				}
				.padding(.all)
				.frame(minWidth: 100, maxWidth: .infinity, alignment: .center)
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
