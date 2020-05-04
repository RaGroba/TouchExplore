//
//  ViewController.swift
//  TouchExplore
//
//  Created by Raphael Grossenbacher on 18.03.20.
//  Copyright © 2020 ZHAW. All rights reserved.
//

import UIKit
import Mapbox
import MapboxGeocoder
import AVFoundation
import CoreHaptics

class ViewController: UIViewController, MGLMapViewDelegate, UIGestureRecognizerDelegate {

    var mapView: MGLMapView!
    var coords: CLLocationCoordinate2D!
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
    
    var streetVibrationPlayer: CHHapticAdvancedPatternPlayer!
    var walkVibrationPlayer: CHHapticAdvancedPatternPlayer!
    var trainVibrationPlayer: CHHapticAdvancedPatternPlayer!
    var signalVibrationPlayer: CHHapticAdvancedPatternPlayer!
    var currentVibrationPlayer: CHHapticAdvancedPatternPlayer!
    
    let chinawieseCoorinates = CLLocationCoordinate2D(latitude: 47.35509424431447, longitude: 8.552054773306253)
    let dolderCoorinates = CLLocationCoordinate2D(latitude: 47.37330964801498, longitude: 8.574133368597018)
    let buerkliplatzCoorinates = CLLocationCoordinate2D(latitude: 47.366245334324674, longitude: 8.540881128030662)
    
    let buildingTypes = ["building","apartments","farm","hotel","house","detached","dormitory","terrace","houseboat","bungalow","cabin","commercial","office","industrial","retail","supermarket","warehouse","kiosk","religious","cathedral","temple","chapel","church","mosque","synagogue","shrine","civic","government","hospital","school","transportation","stadium","train_station","university","grandstand","public","barn","bridge","bunker","carport","conservatory","garage","garages","farm_auxiliary","garbage_shed","greenhouse","hangar","hut","pavilion","parking","roof","sports_hall","shed","stable","service","ruins","transformer_tower","water_tower"]
    
    let footwayTypes = ["footway","path","sidewalk","steps","track:grade1","track:grade2","track:grade3","track:grade4","track:grade5","track","corridor","sidewalk","crossing","piste","mountain_bike","hiking","trail","cycleway","footway","path","bridleway"]
    
    let streetTypes = ["residential",
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
    
    let geocoder = Geocoder.shared
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
             shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
       // Do not begin the pan until the swipe fails.
       if otherGestureRecognizer is UIPanGestureRecognizer && gestureRecognizer is UIPinchGestureRecognizer {
            return true
       } else if otherGestureRecognizer is UIPinchGestureRecognizer && gestureRecognizer is UISwipeGestureRecognizer {
            return true
        }
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        } catch {}
        
        
        let url = URL(string: "mapbox://styles/grossrap/ck9lwxfs42i191ipdaaweevph/draft")
        mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mapView)
        
		mapView.accessibilityActivate()
		// mapView.accessibilityElementsHidden = true
		mapView.isAccessibilityElement = true
		mapView.accessibilityTraits = UIAccessibilityTraits.allowsDirectInteraction
		
        coords = chinawieseCoorinates
        //coords = CLLocationCoordinate2D(latitude: 47.3665, longitude: 8.5415)
        mapView.setCenter(coords, zoomLevel: 18, animated: false)
        
        mapView.allowsRotating = false
        mapView.allowsZooming = false
        mapView.allowsScrolling = false
        mapView.allowsScrolling = false
        mapView.allowsTilting = false
        
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(handleTouch(recognizer:)))
        pan.maximumNumberOfTouches = 1
        pan.delegate = self
        mapView.addGestureRecognizer(pan)
        
        let swipeUp = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipe(recognizer:)))
        swipeUp.numberOfTouchesRequired = 2
        swipeUp.direction = .up
        swipeUp.delegate = self
        mapView.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipe(recognizer:)))
        swipeDown.numberOfTouchesRequired = 2
        swipeDown.direction = .down
        swipeDown.delegate = self
        mapView.addGestureRecognizer(swipeDown)
        
        let swipeRight = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipe(recognizer:)))
        swipeRight.numberOfTouchesRequired = 2
        swipeRight.direction = .right
        swipeRight.delegate = self
        mapView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer.init(target: self, action: #selector(handleSwipe(recognizer:)))
        swipeLeft.numberOfTouchesRequired = 2
        swipeLeft.direction = .left
        swipeLeft.delegate = self
        mapView.addGestureRecognizer(swipeLeft)
        
        let pinch = UIPinchGestureRecognizer.init(target: self, action: #selector(handlePinch(recognizer:)))
        //pinch.delegate = self
        mapView.addGestureRecognizer(pinch)
        
        let twoFingerDoubleTap = UITapGestureRecognizer.init(target: self, action: #selector(handleTwoFingerDoubleTap(recognizer:)))
        twoFingerDoubleTap.numberOfTapsRequired = 2
        twoFingerDoubleTap.numberOfTouchesRequired = 2
        mapView.addGestureRecognizer(twoFingerDoubleTap)
        
        let threeFingerHold = UILongPressGestureRecognizer.init(target: self, action: #selector(handleThreeFingerHold(recognizer:)))
        threeFingerHold.minimumPressDuration = 0.5
        threeFingerHold.numberOfTouchesRequired = 3
        mapView.addGestureRecognizer(threeFingerHold)
        
        let fourFingerHold = UILongPressGestureRecognizer.init(target: self, action: #selector(handleFourFingerHold(recognizer:)))
        fourFingerHold.minimumPressDuration = 0.5
        fourFingerHold.numberOfTouchesRequired = 4
        mapView.addGestureRecognizer(fourFingerHold)
        
        /*let press = UILongPressGestureRecognizer.init(target: self, action: #selector(handleTouch(recognizer:)))
        press.minimumPressDuration = 0
        pinch.delegate = self
        mapView.addGestureRecognizer(press)*/
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTouch(recognizer:)))
        mapView.addGestureRecognizer(tap)
        
        do {
            // (1.) Create an instance of a haptic engine.
            hapticEngine = try CHHapticEngine()

            // (2.) Start the haptic engine.
            try self.hapticEngine.start()
        } catch let error {
            print("Engine Error: \(error)")
        }
        
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
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
        
        synthesize(string: "Willkommen bei TouchExplore. Mit drei Fingern Bildschirm berühren für Anleitung. Bitte schalten Sie VoiceOver aus.")
    }
    
    func featuresAllTheSame(features: [MGLFeature]) -> Bool {
        var allTheSame = true
        for feature in features {
            for secondFeature in features {
                if(allTheSame == true){
                    if !(NSDictionary(dictionary: feature.attributes).isEqual(to: NSDictionary(dictionary: secondFeature.attributes) as! [AnyHashable : Any])) {
                        allTheSame = false
                    }
                }
            }
        }
        print("same: ", allTheSame)
        return allTheSame
    }
    
    func deduplicateFeatures(features: [MGLFeature]) -> [MGLFeature] {
        var filteredFeatures: [MGLFeature] = []
        do {
            filteredFeatures = try features.reduce([], {(initial: [MGLFeature], next: MGLFeature) throws -> [MGLFeature] in
                if (initial.contains(where: { (item: MGLFeature) -> Bool in
                    NSDictionary(dictionary: item.attributes).isEqual(to: NSDictionary(dictionary: next.attributes) as! [AnyHashable : Any])
                })) {
                    print("found Duplikat")
                    return initial
                }
                return initial + [next]
            })
        } catch {
            print("deduplication failed")
        }
        return filteredFeatures
    }
    
    @objc func handleTwoFingerDoubleTap(recognizer: UIGestureRecognizer) {
        let screenLocation = recognizer.location(in: mapView)
        let coords = mapView.convert(screenLocation, toCoordinateFrom: mapView)
        setCenterTo(location: coords)

        //getEnvironment()
    }
    
    func setCenterTo(location: CLLocationCoordinate2D) {
        mapView.setCenter(location, animated: false)
        let options = ReverseGeocodeOptions(coordinate: location)
        let _ = geocoder.geocode(options) { (placemarks, attribution, error) in
            guard let placemark = placemarks?.first else {
                return
            }
            print(placemark.imageName ?? "")
                // telephone
            print(placemark.genres?.joined(separator: ", ") ?? "")
                // computer, electronic
            print(placemark.administrativeRegion?.name ?? "")
                // New York
            print(placemark.administrativeRegion?.code ?? "")
            print(placemark.postalAddress ?? "")

            print(placemark.place?.wikidataItemIdentifier ?? "")
                // Q60
            let street = placemark.postalAddress?.street ?? ""
            let houseNumber = ""
            let city = placemark.postalAddress?.city ?? ""
            let address = street + " " + houseNumber + " " + city
            self.synthesize(string: address)
            print(location)
        }
    }
    
    func getEnvironment() {
        let features = mapView.visibleFeatures(in: mapView.bounds).filter { (feature) -> Bool in
            //return feature.attributes.keys.contains("admin_level")
            return "symbolrank" == feature.attribute(forKey: "type") as! String?
        }.sorted { (feature1, feature2) -> Bool in
            let rank1 = feature1.attribute(forKey: "symbolrank") as! Double
            let rank2 = feature2.attribute(forKey: "symbolrank") as! Double
            
            return rank1 <= rank2
        }
        
        print("*******************")
        for feature in features {
            print(feature.attributes)
            print()
        }
        print("*******************")
    }
    
    @objc func handleThreeFingerHold(recognizer: UIGestureRecognizer) {
        if recognizer.state == .began {
            signalVibration()
            synthesize(string: "Ein Finger über den Bildschirm fahren zum Erkunden. Zwei Finger wischen um in die vier Himmelsrichtungen zu navigieren. Zwei Finger auf- und zusammenziehen zum Zoomen. Mit zwei Fingern doppeltippen um die Karte dort zu zentrieren. Die Applikation funktioniert ab besten, wenn VoiceOver ausgeschaltet ist. Mit drei Fingern Bildschirm berühren für Anleitung.")
        }
        if recognizer.state == .ended {
            signalVibration()
        }
    }
    
    @objc func handleFourFingerHold(recognizer: UIGestureRecognizer) {
        if recognizer.state == .began {
            signalVibration()
            if coords.latitude == chinawieseCoorinates.latitude && coords.longitude == chinawieseCoorinates.longitude {
                coords = dolderCoorinates
                synthesize(string: "Dolder")
            } else if coords.latitude == dolderCoorinates.latitude && coords.longitude == dolderCoorinates.longitude {
                coords = buerkliplatzCoorinates
                synthesize(string: "Bürkliplatz")
            } else {
                coords = chinawieseCoorinates
                synthesize(string: "Chinawiese")
            }
            mapView.setCenter(coords, zoomLevel: 18, animated: false)
        }
        if recognizer.state == .ended {
            signalVibration()
        }
    }
    
    @objc func handleTouch(recognizer: UIGestureRecognizer) {
        
        if (recognizer.state != .ended && recognizer.numberOfTouches < 2){
            
            let point = recognizer.location(in: mapView)
            let features = deduplicateFeatures(features: mapView.visibleFeatures(at: point))
            
            if (features.count > 0) {
                print("FEATURES AT PAN")
            }
            for feature in features {
                print("FEATURE:")
                print(feature.attributes)
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

        } else {
            noFeature()
            print(mapView.convert(recognizer.location(in: mapView), toCoordinateFrom: mapView))
        }
    }
    
    func handleCrossing(streets: [MGLFeature]) {
        var ausgabe = "Kreuzung "
        for street in streets {
            let name = street.attribute(forKey: "name") as! String?
            if (name != nil) {
                ausgabe = ausgabe + name! + " "
            }
        }
        synthesizeCrossing(string: ausgabe)
        
    }
    
    @objc func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        if (recognizer.state == .recognized){
            let currentLong = mapView.centerCoordinate.longitude
            let currentLat = mapView.centerCoordinate.latitude
            var coordinates = mapView.centerCoordinate
    
            let south = mapView.visibleCoordinateBounds.sw.latitude
            let east = mapView.visibleCoordinateBounds.ne.longitude
            
            switch recognizer.direction {
            case .up:
                //synthesize(string: "Sektor nach Süden")
                coordinates = CLLocationCoordinate2D(latitude: currentLat - 2 * (currentLat - south), longitude: currentLong)
            case .down:
                //synthesize(string: "Sektor nach Norden")
                coordinates = CLLocationCoordinate2D(latitude: currentLat + 2 * (currentLat - south), longitude: currentLong)
            case .right:
                //synthesize(string: "Sektor nach Westen")
                coordinates = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong + 2 * (currentLong - east))
            case .left:
                //synthesize(string: "Sektor nach Osten")
                coordinates = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong - 2 * (currentLong - east))
            default:
                print("weird swipe")
            }
            pageFlipSoundPlayer.play()
            setCenterTo(location: coordinates)
            
        } else {
            print("blaaaah")
        }
        
    }
    
    @objc func handlePinch(recognizer: UIPinchGestureRecognizer) {
        if (recognizer.state == .recognized){
            zoomInSoundPlayer.stop()
            zoomOutSoundPlayer.stop()
            if(recognizer.velocity > 0){
                mapView.setZoomLevel(mapView.zoomLevel + 2, animated: false)
                zoomInSoundPlayer.play()
                signalVibration()
                let ausgabe = "Zoom " + String(mapView.zoomLevel) + "-fach"
                synthesize(string: ausgabe)
                getEnvironment()
            } else if recognizer.velocity < 0 {
                print("zoom out")
                mapView.setZoomLevel(mapView.zoomLevel - 2, animated: false)
                zoomOutSoundPlayer.play()
                signalVibration()
                let ausgabe = "Zoom " + String(mapView.zoomLevel) + "-fach"
                synthesize(string: ausgabe)
                getEnvironment()
            }
            
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
            
            switch type {
            case _ where streetTypes.contains(type!):
                currentSoundPlayer = streetSoundPlayer
                currentVibrationPlayer = streetVibrationPlayer
            case _ where forestTypes.contains(type!):
                currentSoundPlayer = forestSoundPlayer
                currentVibrationPlayer = nil
            case _ where footwayTypes.contains(type!):
                if type == "steps" {
                    synthesize(string: "Treppe")
                }
                currentSoundPlayer = footwaySoundPlayer
                currentVibrationPlayer = walkVibrationPlayer
            case "lake":
                currentSoundPlayer = lakeSoundPlayer
                currentVibrationPlayer = nil
            case _ where grassTypes.contains(type!):
                currentSoundPlayer = parkSoundPlayer
                currentVibrationPlayer = nil
            case _ where stadiumTypes.contains(type!):
                currentSoundPlayer = stadiumSoundPlayer
                currentVibrationPlayer = nil
            case _ where playgroundTypes.contains(type!):
                currentSoundPlayer = playgroundSoundPlayer
                currentVibrationPlayer = nil
            case _ where riverTypes.contains(type!):
                currentSoundPlayer = waterSoundPlayer
                currentVibrationPlayer = nil
            case _ where tennisTypes.contains(type!):
                currentSoundPlayer = tennisSoundPlayer
                currentVibrationPlayer = nil
            case _ where golfTypes.contains(type!):
                currentSoundPlayer = golfSoundPlayer
                currentVibrationPlayer = nil
            case "water":
                currentSoundPlayer = waterSoundPlayer
                currentVibrationPlayer = nil
            case _ where railTypes.contains(type!):
                currentSoundPlayer = trainSoundPlayer
                currentVibrationPlayer = trainVibrationPlayer
            case _ where buildingTypes.contains(type!):
                //open door entering building
                currentSoundPlayer = nil
                if (currentFeature == nil || (currentFeature.attributes.count == 0 || !(buildingTypes.contains(currentFeature.attribute(forKey: "type") as! String)))) {
                    doorOpenSoundPlayer.play()
                }
                
                currentVibrationPlayer = nil
            default:
                currentSoundPlayer = nil
                currentVibrationPlayer = nil
            }
            if feature.attribute(forKey: "name") != nil {
                synthesize(string: feature.attribute(forKey: "name") as! String)
            }
            
            do {
                try currentVibrationPlayer?.start(atTime: 0)
            } catch {
                print("could not stop vibration")
            }
            currentSoundPlayer?.play()
            
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
        currentVibrationPlayer = nil
        currentSoundPlayer?.pause()
        currentSoundPlayer = nil
        currentFeature = nil
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
            speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 1.75
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
