import SwiftUI
import CoreHaptics
import AVFoundation
import Combine
import Mapbox

struct MapAccessiblityWrapper<Content: View>: View {
	private let content: Content
	
	private let featureService = FeatureMapper()
	
	@EnvironmentObject var env: MapViewModel
	@ObservedObject var viewModel: FeatureInteractionViewModel
	
	@State private var hapticEngine: CHHapticEngine?
	@State private var feedbackGenerator: UIImpactFeedbackGenerator?
	@State private var speechSynthesizer: AVSpeechSynthesizer?
	
	@State private var currentFeature: MGLFeature?
	@State private var interactionConfig: FeatureConfig?
	
	func prepareHaptics() {
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
		
		print("prepare haptics")
		
		self.feedbackGenerator = UIImpactFeedbackGenerator()
		self.speechSynthesizer = AVSpeechSynthesizer()
		
		do {
			self.hapticEngine = try CHHapticEngine()
			try hapticEngine?.start()
		} catch {
			print("There was an error creating the engine: \(error.localizedDescription)")
		}
	}
	
	func onInteractionChange(data: FeatureInteraction?) {
		self.viewModel.currentValue = data
		
//		self.feedbackGenerator?.prepare()
//
//		self.currentFeature = data?.feature
//		self.interactionConfig = data?.config
//
//		if (data != nil) {
//			self.feedbackGenerator?.impactOccurred()
//			hapticEngine?.accessibilityAssistiveTechnologyFocusedIdentifiers()
//		}
	}
	
	init(viewModel: FeatureInteractionViewModel, @ViewBuilder content: () -> Content) {
		self.viewModel = viewModel
		self.content = content()
	}
	
	var body: some View {
		Group {
			content
		}.onAppear(perform: self.prepareHaptics)
	}
}


//	let hapticEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [
//		CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness), CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
//	], relativeTime: 0)
//	let audioEvent = CHHapticEvent(eventType: .audioContinuous, parameters: [
//		CHHapticEventParameter(parameterID: .audioVolume, value: volume),
//		CHHapticEventParameter(parameterID: .decayTime, value: decay),
//		CHHapticEventParameter(parameterID: .sustained, value: 0),
//	], relativeTime: 0)
//
//	let pattern = try CHHapticPattern(events: [hapticEvent, audioEvent], parameters: [])
//	let hapticPlayer = try engine.makePlayer(with: pattern)
//	try hapticPlayer?.start(atTime: CHHapticTimeImmediate)

// class UIImpactFeedbackGenerator : UIFeedbackGenerator
	
