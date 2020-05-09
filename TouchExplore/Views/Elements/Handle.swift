import SwiftUI

struct Handle : View {
    private let height = CGFloat(5.0)
	private let action: () -> Void
	
	init(action: @escaping () -> Void) {
		self.action = action
	}
	
	var body: some View {
		Button(action: self.action) {
			RoundedRectangle(cornerRadius: height / 2.0)
				.fill(Color.secondary)
				.frame(
					width: 36,
					height: height
				)
		}
	}
	
}
