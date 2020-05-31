import SwiftUI

struct AccessibilityModalView<Content: View>: View {
	private var content: Content
	
	@State var isActive: Bool = false
	
	init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}
	
	var body: some View {
		ZStack {
			content
		}
		.accessibility(label: Text("Karte"))
		.if(self.isActive) {
			$0.accessibility(addTraits: .allowsDirectInteraction)
		}
		.if(!self.isActive) {
			$0.accessibility(hint: Text("Zum interagieren doppeltippen"))
				.accessibilityAction {
					self.isActive = true
				}
		}
    }
}
