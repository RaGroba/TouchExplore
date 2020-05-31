import SwiftUI

struct RootView: View {
	@EnvironmentObject var router: ViewRouter

	private func currentView() -> AnyView {
		switch self.router.currentPage {
			case .IntroView: return AnyView(IntroView())
			case .ContentView: return AnyView(ContentView(viewModel: MapViewModel()))
		}
		
	}
	
	var body: some View {
		currentView()
	}
}

struct RootView_Previews: PreviewProvider {
	static var previews: some View {
		RootView().environmentObject(ViewRouter())
	}
}
