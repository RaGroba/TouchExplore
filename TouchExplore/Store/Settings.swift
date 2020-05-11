import Foundation
import SwiftUI

final class Settings:ObservableObject {
	@Published var count:Double = 0
	@Published var text:String = ""
}
