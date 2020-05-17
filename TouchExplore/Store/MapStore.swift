import Foundation
import Mapbox
import AVFoundation
import CoreHaptics
import SwiftUI


final class MapStore:ObservableObject {
	
	
	private let interactionHandler = MapInteractionHandler();
	
	@Published var testText: String = ""
	
	@Published var features:[MGLFeature] = [MGLFeature]() {
		didSet {
			interactionHandler.onFeatureChange(features: MGLUtils.dedupeFeatures(features: features))
			
			//			let newFeatureIdentifier: AnyObject? = features.first?.identifier as AnyObject?
			//			let oldFeatureIdentifier: AnyObject? = oldValue.first?.identifier as AnyObject?
			
			
			//			if (newFeatureIdentifier !== oldFeatureIdentifier) {
			//				print("Features did change", newFeatureIdentifier, oldFeatureIdentifier)
			//
			//				if (features.count > 0) {
			//
			//					speaker.speak(text: "Neu")
			//				} else {
			//					speaker.speak(text: "Tschüss")
			//				}
			//			}
		}
	}
	
	@Published var zoomLevel:Double = 18 {
		didSet {
			let didChange = oldValue != zoomLevel
			
			if didChange {
				speakZoomlevel(zoomLevel: zoomLevel)
			}
		}
	}
	
	@Published var centerCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 47.3686498, longitude: 8.5391825)
	
	private let speaker = SpeechSynthesizer()
	
	private func speakZoomlevel(zoomLevel: Double) {
		let roundedZoom: Int = Int(zoomLevel.rounded())
		let text: String = "Zoom \(roundedZoom)x"
		
		UIAccessibility.post(notification: UIAccessibility.Notification.announcement,
							 argument: text);

//		speaker.speak(text: text);
	}
	
	private func speakFeature(text: String) {
		
		speaker.speak(text: text);
	}
}

struct SpeechSynthesizer {
	private let speaker = AVSpeechSynthesizer()
	
	// https://www.raywenderlich.com/7237029-ios-accessibility-in-swiftui-tutorial-part-3-adapting
	private let voice = AVSpeechSynthesisVoice(language: NSLocale.preferredLanguages.first)
	
	private func createAVSpeechUtterance(text: String) -> AVSpeechUtterance {
		let utterance = AVSpeechUtterance(string: text)
		
		utterance.voice = voice
		
		return utterance;
	}
	
	func speak(text: String, pauseOthers: Bool = true) -> Void {
		if pauseOthers {
			stopSpeaking()
		}
		
		speaker.speak(createAVSpeechUtterance(text: text))
	}
	
	func stopSpeaking(at: AVSpeechBoundary = .immediate) {
		if speaker.isSpeaking {
			speaker.stopSpeaking(at: at)
		}
	}
}


// MARK: Not Refactorered yet. -------------

class MapInteractionHandler {
	var streetSoundPlayer: AVAudioPlayer!
	var forestSoundPlayer: AVAudioPlayer!
	var lakeSoundPlayer: AVAudioPlayer!
	var riverSoundPlayer: AVAudioPlayer!
	var trainSoundPlayer: AVAudioPlayer!
	var footwaySoundPlayer: AVAudioPlayer!
	var parkSoundPlayer: AVAudioPlayer!
	var waterSoundPlayer: AVAudioPlayer!
	var stadiumSoundPlayer: AVAudioPlayer!
	var tennisSoundPlayer: AVAudioPlayer!
	var golfSoundPlayer: AVAudioPlayer!
	var playgroundSoundPlayer: AVAudioPlayer!
	var pageFlipSoundPlayer: AVAudioPlayer!
	var zoomInSoundPlayer: AVAudioPlayer!
	var zoomOutSoundPlayer: AVAudioPlayer!
	var doorOpenSoundPlayer: AVAudioPlayer!
	var doorCloseSoundPlayer: AVAudioPlayer!
	var currentSoundPlayer: AVAudioPlayer!
	var currentFeature: MGLFeature!
	var speechSynthesizer = AVSpeechSynthesizer()
	var speechCrossingSynthesizer = AVSpeechSynthesizer()
	
	var hapticEngine: CHHapticEngine!
	
	init() {
		do {
			streetSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "motorway", ofType: "mp3")!))
			streetSoundPlayer.numberOfLoops = 99
			forestSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "forest", ofType: "mp3")!))
			forestSoundPlayer.numberOfLoops = 99
			lakeSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "lake", ofType: "wav")!))
			lakeSoundPlayer.numberOfLoops = 99
			riverSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "river", ofType: "mp3")!))
			riverSoundPlayer.numberOfLoops = 99
			trainSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "train", ofType: "mp3")!))
			trainSoundPlayer.numberOfLoops = 99
			footwaySoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "gravel", ofType: "mp3")!))
			footwaySoundPlayer.numberOfLoops = 99
			stadiumSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "stadium", ofType: "mp3")!))
			stadiumSoundPlayer.numberOfLoops = 99
			golfSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "golf", ofType: "mp3")!))
			golfSoundPlayer.numberOfLoops = 99
			tennisSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "tennis", ofType: "mp3")!))
			tennisSoundPlayer.numberOfLoops = 99
			playgroundSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "playground", ofType: "wav")!))
			playgroundSoundPlayer.numberOfLoops = 99
			parkSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "park", ofType: "wav")!))
			parkSoundPlayer.numberOfLoops = 99
			waterSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "water", ofType: "mp3")!))
			waterSoundPlayer.numberOfLoops = 99
			pageFlipSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "pageflip", ofType: "mp3")!))
			zoomInSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "zoom_in", ofType: "mp3")!))
			zoomOutSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "zoom_out", ofType: "mp3")!))
			doorOpenSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "door_open", ofType: "wav")!))
			doorCloseSoundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "door_close", ofType: "mp3")!))
			
			print("Created sound", parkSoundPlayer)
			
		} catch {
			print("There was an error while creating sounds", error)
		}
		
		guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
		
		do {
			hapticEngine = try CHHapticEngine()
			try self.hapticEngine.start()
		} catch {
			print("There was an error creating the engine: \(error.localizedDescription)")
		}
		
		let highIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
		let lowIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.3)
		
		let signalVibrationEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [highIntensity], relativeTime: 0)
		let longHighIntensityVibrationEvent = CHHapticEvent(eventType: .hapticContinuous, parameters: [highIntensity], relativeTime: 0, duration: 100)
		
		let longLowIntensityVibrationEvent = CHHapticEvent(eventType: .hapticContinuous, parameters: [lowIntensity], relativeTime: 0, duration: 100)
		
		let trainVibrationEvent1 = CHHapticEvent(eventType: .hapticContinuous, parameters: [highIntensity], relativeTime: 0.1, duration: 0.24)
		
		
		do {
			let streetPattern = try CHHapticPattern(events: [longHighIntensityVibrationEvent], parameters: [])
			streetVibrationPlayer = try hapticEngine.makeAdvancedPlayer(with: streetPattern)
			streetVibrationPlayer.loopEnabled = true
			
			let walkPattern = try CHHapticPattern(events: [longLowIntensityVibrationEvent], parameters: [])
			walkVibrationPlayer = try hapticEngine.makeAdvancedPlayer(with: walkPattern)
			walkVibrationPlayer.loopEnabled = true
			
			
			let trainPattern = try CHHapticPattern(events: [trainVibrationEvent1], parameters: [])
			trainVibrationPlayer = try hapticEngine.makeAdvancedPlayer(with: trainPattern)
			trainVibrationPlayer.loopEnabled = true
			
			let signalPattern = try CHHapticPattern(events: [signalVibrationEvent], parameters: [])
			
			signalVibrationPlayer = try hapticEngine.makeAdvancedPlayer(with: signalPattern)
			signalVibrationPlayer.loopEnabled = false
		} catch {
			print("Failed to run taptic engine")
		}
	}
	
	let buildingTypes = ["building","apartments","farm","hotel","house","detached","dormitory","terrace","houseboat","bungalow","cabin","commercial","office","industrial","retail","supermarket","warehouse","kiosk","religious","cathedral","temple","chapel","church","mosque","synagogue","shrine","civic","government","hospital","school","transportation","stadium","train_station","university","grandstand","public","barn","bridge","bunker","carport","conservatory","garage","garages","farm_auxiliary","garbage_shed","greenhouse","hangar","hut","pavilion","parking","roof","sports_hall","shed","stable","service","ruins","transformer_tower","water_tower"]
	
	let footwayTypes = ["footway","path","sidewalk","steps","track:grade1","track:grade2","track:grade3","track:grade4","track:grade5","track","corridor","sidewalk","crossing","piste","mountain_bike","hiking","trail","cycleway","footway","path","bridleway"]
	
	let streetTypes = [
		"residential",
		"street",
		"street_limited",
		"secondary",
		"residential",
		"tertiary",
		"primary",
		"motorway",
	]
	
	let stadiumTypes = ["sports_centre","athletics", "soccer"]
	
	let tennisTypes = ["tennis"]
	
	let golfTypes = ["golf_course", "golf"]
	
	let playgroundTypes = ["playground"]
	
	let railTypes = ["tram", "train", "rail", "narrow_gauge"]
	
	let grassTypes = ["grass", "park", "meadow", "garden", "recreation_ground", "wood"]
	
	let riverTypes = ["river", "chanel", "stream", "stream_intermittent", "drain", "ditch"]
	
	let forestTypes = ["forest"]
	
	var streetVibrationPlayer: CHHapticAdvancedPatternPlayer!
	var walkVibrationPlayer: CHHapticAdvancedPatternPlayer!
	var trainVibrationPlayer: CHHapticAdvancedPatternPlayer!
	var signalVibrationPlayer: CHHapticAdvancedPatternPlayer!
	@State var currentVibrationPlayer: CHHapticAdvancedPatternPlayer!
	
	func onFeatureChange(features: [MGLFeature]) {
		for feature in features {
			print("Feature:", feature.attributes)
		}
		
		// Get high priority features
		let rails = features.filter({(item: MGLFeature) -> Bool in
			let type = item.attribute(forKey: "type") as! String?
			return type != nil && railTypes.contains(type!)
			
		})
		
		let streets = features.filter({(item: MGLFeature) -> Bool in
			var type = item.attribute(forKey: "type") as! String?
			if type == "unclassified" {
				type = item.attribute(forKey: "class") as! String?
			}
			return type != nil && (footwayTypes.contains(type!) || streetTypes.contains(type!))
		})
		
		let buildings = features.filter({(item: MGLFeature) -> Bool in
			let type = item.attribute(forKey: "type") as! String?
			return type != nil && buildingTypes.contains(type!)
		})
		
		let waters = features.filter({(item: MGLFeature) -> Bool in
			return item.attributes.count == 0
		})
		
		let rivers = features.filter({(item: MGLFeature) -> Bool in
			let type = item.attribute(forKey: "type") as! String?
			return type != nil && riverTypes.contains(type!)
		})
		
		let stadiums = features.filter({(item: MGLFeature) -> Bool in
			let type = item.attribute(forKey: "type") as! String?
			return type != nil && stadiumTypes.contains(type!)
		})
		
		let playgrounds = features.filter({(item: MGLFeature) -> Bool in
			let type = item.attribute(forKey: "type") as! String?
			return type != nil && playgroundTypes.contains(type!)
		})
		
		let grasses = features.filter({(item: MGLFeature) -> Bool in
			let type = item.attribute(forKey: "type") as! String?
			return type != nil && grassTypes.contains(type!)
		})
		
		let forests = features.filter({(item: MGLFeature) -> Bool in
			let type = item.attribute(forKey: "type") as! String?
			return type != nil && forestTypes.contains(type!)
		})
		
		
		//handle hight priority features
		if (rails.count > 0) {
			featureHandler(feature: rails.first!)
		} else if (streets.count > 1) {
			handleCrossing(streets: streets)
		} else if (streets.count == 1) {
			featureHandler(feature: streets.first!)
		} else if (playgrounds.count >= 1) {
			featureHandler(feature: playgrounds.first!)
		} else if (stadiums.count >= 1) {
			featureHandler(feature: stadiums.first!)
		} else if (buildings.count >= 1) {
			featureHandler(feature: buildings.first!)
		} else if (waters.count > 0) {
			featureHandler(feature: waters.first!)
		} else if (rivers.count > 0) {
			featureHandler(feature: rivers.first!)
		} else if (grasses.count > 0) {
			featureHandler(feature: grasses.first!)
		} else if (forests.count > 0) {
			featureHandler(feature: forests.first!)
		} else {
			if features.count > 0 {
				featureHandler(feature: features.first!)
			}
		}
		
		if features.count == 0 {
			noFeature()
		}
	}
	
	func featureHandler(feature: MGLFeature){
		if currentFeature == nil || !featuresAreEqual(feature1: feature, feature2: currentFeature) {
			featureChange(feature: feature)
		} else {
			currentFeature = feature
		}
	}
	
	func signalVibration() {
		do {
			if signalVibrationPlayer.isMuted {
				signalVibrationPlayer.isMuted = false
			}
			try signalVibrationPlayer?.start(atTime: 0)
		} catch {}
	}
	
	func handleCrossing(streets: [MGLFeature]) {
		let streetNames: [String] = Array(Set(streets.compactMap({
			$0.attribute(forKey: "name") as? String
		})))
		
		if streetNames.count > 0 {
			let sentence = streetNames.reduce("Kreuzung") {
				"\($0) \($1)"
			}
			
			synthesizeCrossing(string: sentence)
		}
	}
	
	
	func featureChange(feature: MGLFeature){
		currentSoundPlayer?.pause()
		speechSynthesizer.stopSpeaking(at: AVSpeechBoundary(rawValue: 0)!)
		
		
		do {
			try currentVibrationPlayer?.pause(atTime: 0)
		} catch {
			print("could not stop vibration")
		}
		
		if feature.attribute(forKey: "type") != nil || feature.attributes.count == 0 {
			signalVibration()
			var type = feature.attribute(forKey: "type") as! String?
			if feature.attributes.count == 0 {
				type = "water"
			}
			if type == "unclassified" {
				type = feature.attribute(forKey: "class") as! String?
			}
			
			//close door if leave building
			if (currentFeature != nil) {
				let typeOfCurrentFeature = currentFeature.attribute(forKey: "type") as! String?
				if typeOfCurrentFeature != nil && buildingTypes.contains(typeOfCurrentFeature!) {
					let typeOfFeature = feature.attribute(forKey: "type") as! String?
					if typeOfFeature != nil && !buildingTypes.contains(typeOfFeature!) {
						doorCloseSoundPlayer.play()
					}
				}
			}
			
			print("currentFeature", type ?? "")
			
			switch type {
				case _ where streetTypes.contains(type!):
					self.currentSoundPlayer = streetSoundPlayer
					self.currentVibrationPlayer = streetVibrationPlayer
				case _ where forestTypes.contains(type!):
					self.currentSoundPlayer = forestSoundPlayer
					self.currentVibrationPlayer = nil
				case _ where footwayTypes.contains(type!):
					if type == "steps" {
						synthesize(string: "Treppe")
					}
					self.currentSoundPlayer = footwaySoundPlayer
					self.currentVibrationPlayer = walkVibrationPlayer
				case "lake":
					self.currentSoundPlayer = lakeSoundPlayer
					self.currentVibrationPlayer = nil
				case _ where grassTypes.contains(type!):
					self.currentSoundPlayer = parkSoundPlayer
					self.currentVibrationPlayer = nil
				case _ where stadiumTypes.contains(type!):
					self.currentSoundPlayer = stadiumSoundPlayer
					self.currentVibrationPlayer = nil
				case _ where playgroundTypes.contains(type!):
					self.currentSoundPlayer = playgroundSoundPlayer
					self.currentVibrationPlayer = nil
				case _ where riverTypes.contains(type!):
					self.currentSoundPlayer = waterSoundPlayer
					self.currentVibrationPlayer = nil
				case _ where tennisTypes.contains(type!):
					self.currentSoundPlayer = tennisSoundPlayer
					self.currentVibrationPlayer = nil
				case _ where golfTypes.contains(type!):
					self.currentSoundPlayer = golfSoundPlayer
					self.currentVibrationPlayer = nil
				case "water":
					self.currentSoundPlayer = waterSoundPlayer
					self.currentVibrationPlayer = nil
				case _ where railTypes.contains(type!):
					self.currentSoundPlayer = trainSoundPlayer
					self.currentVibrationPlayer = trainVibrationPlayer
				case _ where buildingTypes.contains(type!):
					//open door entering building
					self.currentSoundPlayer = nil
					if (currentFeature == nil || (currentFeature.attributes.count == 0 || !(buildingTypes.contains(currentFeature.attribute(forKey: "type") as! String)))) {
						doorOpenSoundPlayer.play()
					}
					
					currentVibrationPlayer = nil
				default:
					self.currentSoundPlayer = nil
					self.currentVibrationPlayer = nil
			}
			if feature.attribute(forKey: "name") != nil {
				synthesize(string: feature.attribute(forKey: "name") as! String)
			}
			
			do {
				try currentVibrationPlayer?.start(atTime: 0)
			} catch {
				print("could not stop vibration")
			}
			
			print("try to play current sound", currentSoundPlayer)
			self.currentSoundPlayer?.play()
			
		} else {
			noFeature()
		}
		currentFeature = feature
	}
	
	func noFeature(){
		//close door if leaving building
		if currentFeature != nil {
			let typeOfCurrentFeature = currentFeature.attribute(forKey: "type") as! String?
			if typeOfCurrentFeature != nil && buildingTypes.contains(typeOfCurrentFeature!) {
				doorCloseSoundPlayer.play()
			}
		}
		
		if (currentFeature != nil) {
			signalVibration()
		}
		do {
			try currentVibrationPlayer?.cancel()
		} catch {
			print("could not stop vibration")
		}
		self.currentVibrationPlayer = nil
		currentSoundPlayer?.pause()
		self.currentSoundPlayer = nil
		self.currentFeature = nil
		speechSynthesizer.stopSpeaking(at: AVSpeechBoundary(rawValue: 0)!)
	}
	
	func synthesize(string: String){
		if speechSynthesizer.isSpeaking {
			speechSynthesizer.stopSpeaking(at: AVSpeechBoundary(rawValue: 0)!)
		}
		let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: string)
		speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 1.8
		speechUtterance.voice = AVSpeechSynthesisVoice(language: "de-CH")
		speechSynthesizer.speak(speechUtterance)
	}
	
	func synthesizeCrossing(string: String){
		if speechCrossingSynthesizer.isSpeaking {
			
		} else {
			let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: string)
			speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 1.8
			speechUtterance.voice = AVSpeechSynthesisVoice(language: "de-CH")
			speechCrossingSynthesizer.speak(speechUtterance)
		}
	}
	
	func featuresAreEqual(feature1: MGLFeature, feature2: MGLFeature) -> Bool {
		if feature2.attributes.count == 0 && feature1.attributes.count > 0 {
			print("CHANGE*******************")
		}
		
		let attributes1 = feature1.attributes.filter { (key: String, value: Any) -> Bool in
			return key == "class" || key == "type" || key == "name"
		}
		
		let attributes2 = feature2.attributes.filter { (key: String, value: Any) -> Bool in
			return key == "class" || key == "type" || key == "name"
		}
		
		var equal = true
		
		for attr in attributes1 {
			if attributes2.keys.contains(attr.key){
				if !(attr.value as! String == attributes2[attr.key] as! String) {
					equal = false
				}
			} else {
				equal = false
			}
		}
		
		for attr in attributes2 {
			if attributes1.keys.contains(attr.key){
				if !(attr.value as! String == attributes1[attr.key] as! String) {
					equal = false
				}
			} else {
				equal = false
			}
		}
		return equal
	}
}
