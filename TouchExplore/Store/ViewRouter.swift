import Foundation
import Combine
import SwiftUI

class ViewRouter: ObservableObject {	
	let objectWillChange = PassthroughSubject<ViewRouter,Never>()
	
	var currentPage: Routes = Routes.IntroView {
		didSet {
			objectWillChange.send(self)
		}
	}
}

enum Routes: String {
    case
		ContentView = "CONTENT_VIEW",
		IntroView = "INTRO_VIEW"
}
