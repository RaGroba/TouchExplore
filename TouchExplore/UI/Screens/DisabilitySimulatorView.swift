import SwiftUI

class DisabilitySimulatorViewModel: ObservableObject, Identifiable {
	@Published var disabilities = DisabilitySimulator()
	
	@Published var isHidden: Bool = false {
		willSet {
			self.disabilities.blindness = newValue ? 1 : 0
		}
	}
	
	func reset() {
		self.disabilities.reset()
	}
}

struct DisabilitySimulatorView: View {
	@ObservedObject var vm: DisabilitySimulatorViewModel
		
	var body: some View {
		return Form {
			Section(header: Text("Visibility (Transparency)")) {
				HStack {
					Toggle("Hide map visually", isOn: self.$vm.isHidden)
				}
				HStack {
					Slider(value: self.$vm.disabilities.blindness, in: 0...1, step: 0.01)
					Text("\(Int(self.vm.disabilities.blindness * 100))%").accessibility(hidden: true)
				}.disabled(self.vm.isHidden)
			}
			Section(header: Text("Blur")) {
				HStack {
					Slider(value: self.$vm.disabilities.blur, in: 0...30, step: 1).accessibility(value: Text("\(Int(self.vm.disabilities.blur))"))
					Text("\(Int(self.vm.disabilities.blur))px").accessibility(hidden: true)
				}
			}
			Section(header: Text("Grayscale")) {
				HStack {
					Slider(value: self.$vm.disabilities.grayscale, in: 0...1, step: 0.01)
					Text("\(Int(self.vm.disabilities.grayscale * 100))%").accessibility(hidden: true)
				}
			}
			Section(header: Text("Contrast")) {
				HStack {
					Slider(value: self.$vm.disabilities.contrast, in: 1...2, step: 0.01)
					Text("\(String(format: "%.2f", self.vm.disabilities.contrast))").accessibility(hidden: true)
				}
			}
			
			Section {
				HStack {
					Button(action: {
						self.vm.reset()
					}) {
						Text("Reset all settings").foregroundColor(Color.red)
					}
				}
			}
			
			Section(header: Text("Preview")) {
				HStack {
					Spacer()
					Group {
						Image(decorative: "map-example")
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: 300, height: 250.0, alignment: .center)
							.clipped()
							.disabilitySimulator(values: self.vm.disabilities)
					}.frame(width: 300, height: 250.0, alignment: .center)
						.clipped()
					Spacer()
				}.padding(.top).padding(.bottom)
			}
		}
	}
}


extension View {
	func disabilitySimulator(values: DisabilitySimulator?) -> some View {
		return self.modifier(DisabilitySimulatorViewModifier(values: values))
    }
}

fileprivate struct DisabilitySimulatorViewModifier: ViewModifier {
	var values: DisabilitySimulator?

	private let minOpacity = 0.01;
	
    func body(content: Content) -> some View {
		guard let values = self.values else { return AnyView(content) }
		
		return AnyView(content
			.blur(radius: CGFloat(values.blur))
			.grayscale(min(values.grayscale, 0.99))
			.contrast(values.contrast)
			.opacity(max(minOpacity, 1 - values.blindness))
			// .mask(overlay().compositingGroup().opacity(1 - self.values.opacity))
		)
	}
	
	func overlay() -> some View {
		Rectangle().fill(Color.red).frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
	}
}

struct DisabilitySimulatorConfigView_Previews: PreviewProvider {
    static var previews: some View {
		DisabilitySimulatorView(vm: DisabilitySimulatorViewModel())
    }
}
