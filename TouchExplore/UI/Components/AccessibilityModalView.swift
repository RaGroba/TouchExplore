import SwiftUI

struct AccessibilityModalView<Content: View>: View {
	private var content: Content
	
	@Binding var isActive: Bool
	
	init(isActive: Binding<Bool> ,@ViewBuilder content: () -> Content) {
		self._isActive = isActive
		self.content = content()
	}
	
	var body: some View {
		ZStack {
			content
		}
		.accessibility(label: Text("Karte"))
		.if(self.isActive) {
			$0.accessibility(hint: Text("Zum beenden mit drei fingern nach oben streichen."))
				.accessibility(addTraits: .allowsDirectInteraction)
				.accessibility(addTraits: .isModal)
		}
		.if(!self.isActive) {
			$0.accessibility(hint: Text("Zum interagieren doppeltippen. Um danach zurück in den VoiceOver Modus zu wechseln mit drei fingern nach oben streichen."))
				.accessibilityAction {
					self.isActive = true
				}
		}
    }
}
