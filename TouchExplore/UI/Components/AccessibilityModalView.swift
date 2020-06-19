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
		.accessibility(label: Text("Map"))
		.if(self.isActive) {
			$0.accessibility(hint: Text("To exit map and switch back to VoiceOver-mode swipe up with three fingers."))
				.accessibility(addTraits: .allowsDirectInteraction)
				.accessibility(addTraits: .isModal)
		}
		.if(!self.isActive) {
			$0.accessibility(hint: Text("Doubletap to activate. To exit it again (and go back to voiceover-mode) swipe up with three fingers."))
				.accessibilityAction {
					self.isActive = true
				}
		}
    }
}
