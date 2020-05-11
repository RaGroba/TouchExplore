import SwiftUI

struct DemoView: View {
	@Binding var count:Double
	
    var body: some View {
		VStack {
			Spacer()
			HStack {
				Button(action: {
					self.count += 1
				}) {
					Text("More")
				}
				
				Text("Counter: \(count)")
				
				Button(action: {
					self.count += 1
				}) {
					Text("Less")
				}
			}
			Spacer()
		}
	}
}

struct DemoView_Previews: PreviewProvider {
	@State static var count:Double = 0
	
	static var previews: some View {
		DemoView(count: $count)
    }
}
