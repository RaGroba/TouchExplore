import SwiftUI

struct DisabilitySimulatorConfigView: View {
	@ObservedObject var vm: DisabilitySimulatorConfigViewModel = DisabilitySimulatorConfigViewModel()
	
	var body: some View {
		return Form {
			Section(header: Text("Sichtbarkeit (Transparenz)")) {
				HStack {
					Toggle("Karte visuell ausblenden", isOn: self.$vm.isHidden)
				}
				HStack {
					Slider(value: self.$vm.blindness, in: 0...100, step: 1)
					Text("\(Int(self.vm.blindness))%")
				}.disabled(self.vm.isHidden)
			}
			Section(header: Text("Myopie (Blur)")) {
				HStack {
					Slider(value: self.$vm.myopia, in: 0...20, step: 1)
					Text("\(Int(self.vm.myopia))px")
				}
			}
			Section(header: Text("Grayscale")) {
				HStack {
					Slider(value: self.$vm.colors, in: 1...100, step: 1)
					Text("\(Int(self.vm.colors))%")
				}
			}
			Section(header: Text("Kontrast")) {
				HStack {
					Slider(value: self.$vm.contrast, in: 1...100, step: 1)
					Text("\(Int(self.vm.contrast))%")
				}
			}
			
			Section(header: Text("Vorschau")) {
				HStack {
					Spacer()
					Group {
						Image(decorative: "map-example")
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: 300, height: 250.0, alignment: .center)
							.clipped()
							.blur(radius: CGFloat(self.vm.myopia))
							.grayscale(self.vm.colors / 100)
							.contrast(1 - self.vm.contrast / 100)
							.opacity(1 - self.vm.blindness / 100)
					}.frame(width: 300, height: 250.0, alignment: .center)
						.clipped()
					Spacer()
				}.padding(.top).padding(.bottom)
			}
		}
    }
}
//
//extension View {
//    func disabilitySimulator() -> some View {
//        self.modifier(DisabilitySimulator())
//    }
//}
//
//struct DisabilitySimulator: ViewModifier {
//	@ObservedObject var vm: DisabilitySimulatorConfigViewModel = DisabilitySimulatorConfigViewModel()
//
//    func body(content: Content) -> some View {
//        content
//			.blur(radius: CGFloat(self.vm.myopia))
//			.grayscale(self.vm.colors / 100)
//			.contrast(1 - self.vm.contrast / 100)
//			.opacity(1 - self.vm.blindness / 100)
//    }
//}

class DisabilitySimulatorConfigViewModel: ObservableObject, Identifiable {
	@Published var myopia: Double = 0
	@Published var colors: Double = 0
	@Published var contrast: Double = 1
	@Published var blindness: Double = 0
	
	@Published var isHidden: Bool = false {
		didSet {
			self.blindness = self.isHidden ? 100 : 0
		}
	}
}

struct DisabilitySimulatorConfigView_Previews: PreviewProvider {
    static var previews: some View {
        DisabilitySimulatorConfigView()
    }
}
