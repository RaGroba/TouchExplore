import SwiftUI

fileprivate enum Constants {
    static let radius: CGFloat = 10
    static let snapRatio: CGFloat = 0.1
    static let minHeightRatio: CGFloat = 0.15
}

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    @GestureState private var translation: CGFloat = 0
	
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
	
	private func open() {
		self.isOpen = true
	}
	
	private func close() {
		self.isOpen = false
		
		UIApplication.shared.endEditing(true)
	}
	
	private func toggle() {
		self.isOpen = !self.isOpen
		
		UIApplication.shared.endEditing(true)
	}
	
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
				Handle(action: {
					self.toggle()
				}).padding(.top, 5).opacity(0.8).accessibility(value: self.isOpen ? Text("Kartensteuerung schliessen") : Text("Kartensteuerung öffnen"))
                self.content
			}
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
			.background(Color(.secondarySystemBackground))
			.cornerRadius(Constants.radius, antialiased: true)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
              
					UIApplication.shared.endEditing(true)
				}.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
		}.accessibility(addTraits: .isModal)
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			BottomSheetView(isOpen: .constant(false), maxHeight: 600) {
				Text("Hello World!")
			}.edgesIgnoringSafeArea(.all)
			BottomSheetView(isOpen: .constant(true), maxHeight: 600) {
				Text("Hello World!")
			}.edgesIgnoringSafeArea(.all)
		}
    }
}
