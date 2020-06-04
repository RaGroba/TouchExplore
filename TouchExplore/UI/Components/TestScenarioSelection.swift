import SwiftUI

struct TestScenarioSelection: View {
	var onSelect: (TestSetup) -> Void
	
	private let testSetups: [TestSetup] = [
		TestSetup(
			title: "Szenario 1",
			description: "Erkundung normal",
			mapConfig: Map(zoomLevel: 18, centerCoordinate: Locations.Chinagarten),
			disabilities: DisabilitySimulator()
		),
		TestSetup(
			title: "Szenario 2",
			description: "Erkundung normal",
			mapConfig: Map(zoomLevel: 18, centerCoordinate: Locations.Dolder),
			disabilities: DisabilitySimulator()
		),
		TestSetup(
			title: "Szenario 3",
			description: "Erkundung normal",
			mapConfig: Map(zoomLevel: 18, centerCoordinate: Locations.Buerkliplatz),
			disabilities: DisabilitySimulator()
		),
        TestSetup(
            title: "Simulator 1",
            description: "Erkundung Blur",
            mapConfig: Map(zoomLevel: 18, centerCoordinate: Locations.Zurich),
            disabilities: DisabilitySimulator(blur: 20)
        ),
        TestSetup(
            title: "Simulator 2",
            description: "Erkundung Blur Blind 95%",
            mapConfig: Map(zoomLevel: 18, centerCoordinate: Locations.Zurich),
            disabilities: DisabilitySimulator(blur: 30, blindness: 0.95)
        ),
        TestSetup(
            title: "Simulator 3",
            description: "Erkundung Blur Grayscale 1",
            mapConfig: Map(zoomLevel: 18, centerCoordinate: Locations.Zurich),
            disabilities: DisabilitySimulator(blur: 30, grayscale: 1)
        )
	]
	
	var body: some View {
		Form {
			Section(header: Text("Testszenarien laden")) {
				List(testSetups, id: \.title) { setup in
					TestScenarioButton(title: setup.title, description: setup.description, mapConfig: setup.mapConfig, action: { 
						self.onSelect(setup)
					})
				}.animation(nil)
			}
		}
	}
}

fileprivate struct TestScenarioButton: View {
	var title: String
	var description: String
	
	var mapConfig: Map
	
	var action: () -> Void
	
	var body: some View {
		Button(action: action) {
			VStack(alignment: .leading) {
				Text(title).font(.headline).foregroundColor(.primary)
				
				Text(description)
					.font(.caption)
					.foregroundColor(Color.gray)
					.accessibility(hidden: true)
			}.padding(.top, 8.0).padding(.bottom, 8.0)
		}
	}
}

struct TestScenarioSelection_Previews: PreviewProvider {
	static var previews: some View {
		TestScenarioSelection(onSelect: { _ in})
	}
}
