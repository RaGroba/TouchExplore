import SwiftUI

struct DisabilitySimulatorConfigView: View {
	@State var myopia: Double = 0
	@State var colors: Double = 0
	@State var contrast: Double = 100
	
	var body: some View {
		Form {
			Section(header: Text("Myopia")) {
				HStack {
					Slider(value: self.$myopia, in: 0...20, step: 1)
					Text("\(Int(self.myopia))px")
				}
			}
			Section(header: Text("Colors (Grayscale)")) {
				HStack {
					Slider(value: self.$colors, in: 0...100, step: 1)
					Text("\(Int(self.colors))%")
				}
			}
			Section(header: Text("Contrast")) {
				HStack {
					Slider(value: self.$contrast, in: 0...100, step: 1)
					Text("\(Int(self.contrast))%")
				}
			}
		}.blur(radius: CGFloat(self.myopia)).grayscale(self.colors)
    }
}

struct DisabilitySimulatorConfigView_Previews: PreviewProvider {
    static var previews: some View {
        DisabilitySimulatorConfigView()
    }
}
