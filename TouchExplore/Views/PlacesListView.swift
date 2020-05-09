import SwiftUI
import MapKit

struct PlacesListView: View {
	var landmarks:[Landmark]
	
	init(landmarks: [Landmark]) {
		self.landmarks = landmarks
		
		UIScrollView.appearance().bounces = false
	}
	
    var body: some View {
		List(self.landmarks, id: \.id) { landmark in
			Group {
				VStack(alignment: .leading) {
					Text(landmark.name)
					
					if (landmark.locality != nil && landmark.country != nil) {
						Text([landmark.locality, landmark.country].compactMap{ $0 }.joined(separator: ", "))
					}
				}.accessibilityElement(children: .combine)
			}
			.id(landmark.id)
			.onTapGesture {
				print("Click on \(landmark)")
			}
		}.id(UUID()).animation(nil)
	}
}

struct PlacesListView_Previews: PreviewProvider {
    static var previews: some View {
		PlacesListView(landmarks: [])
    }
}
