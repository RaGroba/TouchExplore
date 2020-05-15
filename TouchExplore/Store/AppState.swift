import SwiftUI
import Combine

class AppState: ObservableObject {
	var userSettings = UserSettings()
}

extension AppState {
    struct UserSettings: Equatable {
       
    }
}
