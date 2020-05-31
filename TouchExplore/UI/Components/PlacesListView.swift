import SwiftUI
import MapKit

struct PlacesListView: View {
	var landmarks:[Landmark]

	var onTapAction: (Landmark) -> Void
	
	init(landmarks: [Landmark], onTapAction: @escaping (Landmark) -> Void) {
		self.landmarks = landmarks
		self.onTapAction = onTapAction
		
		UIScrollView.appearance().bounces = false
	}
	
    var body: some View {
		List(self.landmarks, id: \.id) { landmark in
			Button(action: {
				self.onTapAction(landmark)
			}) {
				HStack {
					VStack(alignment: .leading) {
						Text(landmark.name).font(.headline)
						
						if (landmark.locality != nil && landmark.country != nil) {
							Text([landmark.locality, landmark.country].compactMap{ $0 }.joined(separator: ", ")).font(.caption).foregroundColor(Color.gray)
						}
					}
					Spacer()
				}.accessibilityElement(children: .combine).padding(.top, 8).padding(.bottom, 8)
			}.id(landmark.id)
		}.id(UUID()).animation(nil)
	}
}

struct PlacesListView_Previews: PreviewProvider {
    static var previews: some View {
		PlacesListView(landmarks: [], onTapAction: { landmark in
			print("on tap:", landmark)
		})
    }
}
