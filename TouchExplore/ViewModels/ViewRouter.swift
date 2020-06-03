import Foundation
import Combine
import SwiftUI
import UIKit

class ViewRouter: ObservableObject {	
	let objectWillChange = PassthroughSubject<ViewRouter,Never>()
	
	var currentPage: Routes = Routes.IntroView {
		didSet {
			objectWillChange.send(self)
				
			UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: "")
		}
	}
	
	func goto(_ route: Routes) {
		self.currentPage = route;
	}
}

enum Routes: String {
    case
		ContentView = "CONTENT_VIEW",
		IntroView = "INTRO_VIEW"
}
