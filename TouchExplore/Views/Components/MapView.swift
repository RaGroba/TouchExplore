import SwiftUI
import Mapbox
import AVFoundation

struct MapView: UIViewRepresentable {	
    private static var styleURL: URL {
		if let styleUrlFromDict = Bundle.main.object(forInfoDictionaryKey: "MGL_STYLE_URL") as? String {
			return URL(string: styleUrlFromDict)!
		}
		
		return MGLStyle.streetsStyleURL
    }

	var locationManager: CLLocationManager
	
	@Binding var zoomLevel:Double
	@Binding var features:[MGLFeature]
	@Binding var centerCoordinate:CLLocationCoordinate2D
	
	private let mapView: MGLMapView = MGLMapViewCustom(frame: .zero, styleURL: MapView.styleURL)
    
    // MARK: - Configuring UIViewRepresentable protocol
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MGLMapView {
		mapView.delegate = context.coordinator
		
		self.enableUserLocationTracking()
		self.disableInteractions()
		self.setAccessiblityProperties()
		self.bindListeners(target: mapView)
		
		return mapView
    }
	
    func makeCoordinator() -> MapView.Coordinator {
		Coordinator(self, map: mapView)
    }
    	
    func updateUIView(_ view: MGLMapView, context: UIViewRepresentableContext<MapView>) {
		view.zoomLevel = self.zoomLevel
		view.setCenter(self.centerCoordinate, animated: false)
	}
    
	private func enableUserLocationTracking() {
		mapView.showsUserLocation = true
		mapView.locationManager.setDesiredAccuracy?(kCLLocationAccuracyBest)
	}
	
	private func setAccessiblityProperties() {		
//		mapView.accessibilityActivate()
		mapView.accessibilityElementsHidden = true
		mapView.isAccessibilityElement = false
		mapView.accessibilityTraits = UIAccessibilityTraits.allowsDirectInteraction
	}
	
	private func disableInteractions() {
		mapView.isPitchEnabled = false
		mapView.isRotateEnabled = false
		mapView.isScrollEnabled = false
		mapView.isZoomEnabled = false
	}
	
	private func bindListeners(target: MGLMapView) {
		// Double-Tap 1 Finger: Center Map
		let doubleTapGesture = UITapGestureRecognizer(target: mapView.delegate, action: #selector(Coordinator.onDoubleTapped(gestureRecognizer:)))
		doubleTapGesture.numberOfTapsRequired = 2
		target.addGestureRecognizer(doubleTapGesture)
		
		// Pinch: Zoom in and out
		let pinchGesture = UIPinchGestureRecognizer(target: mapView.delegate, action: #selector(Coordinator.onPinched(gestureRecognizer:)))
		target.addGestureRecognizer(pinchGesture)
		
		// Touchmove: detect current feature
		let moveGesture = UIPanGestureRecognizer(target: mapView.delegate, action: #selector(Coordinator.onTouchMove))
		moveGesture.maximumNumberOfTouches = 1
		target.addGestureRecognizer(moveGesture)
		
		// Two-Finger swipe: navigate by sector/page
		for direction in [UISwipeGestureRecognizer.Direction.left, UISwipeGestureRecognizer.Direction.right, UISwipeGestureRecognizer.Direction.up, UISwipeGestureRecognizer.Direction.down] {
			let twoFingerSwipeGesture = UISwipeGestureRecognizer(target: mapView.delegate, action: #selector(Coordinator.onTwoFingerSwipe))
			twoFingerSwipeGesture.numberOfTouchesRequired = 2
			twoFingerSwipeGesture.direction = direction
			target.addGestureRecognizer(twoFingerSwipeGesture)
		}
	}
	
    // MARK: - Configuring MGLMapView
    func styleURL(_ styleURL: URL) -> MapView {
        mapView.styleURL = styleURL
		
        return self
    }

	func moveMapBySector(to: UISwipeGestureRecognizer.Direction) {
		let bounds = mapView.visibleCoordinateBounds

		let currentLong = mapView.centerCoordinate.longitude
		let currentLat = mapView.centerCoordinate.latitude
		
		let deltaHeight = abs(bounds.sw.longitude - bounds.ne.longitude)
		let deltaWidth = abs(bounds.sw.latitude - bounds.ne.latitude)
		
		if (to == .left) {
			mapView.setCenter(CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong + deltaHeight), animated: true)
		} else if (to == .right) {
			mapView.setCenter(CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong - deltaHeight), animated: true)
		} else if (to == .up) {
			mapView.setCenter(CLLocationCoordinate2D(latitude: currentLat - deltaWidth, longitude: currentLong), animated: true)
		} else if (to == .down) {
			mapView.setCenter(CLLocationCoordinate2D(latitude: currentLat + deltaWidth, longitude: currentLong), animated: true)
		}

		UIAccessibility.post(notification: UIAccessibility.Notification.pageScrolled,
							 argument: "");
	}
	
    // MARK: - Implementing MGLMapViewDelegate
    
	final class Coordinator: NSObject, MGLMapViewDelegate, UIGestureRecognizerDelegate {
        private var parent: MapView
		private var map: MGLMapView
        
		init(_ parent: MapView, map: MGLMapView) {
            self.parent = parent
			self.map = map
        }

		func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
			print("mapViewDidFinishLoadingMap");
	
			mapView.setCenter((mapView.userLocation?.coordinate)!, animated: false)
		}
		
		func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
			print("didFinishLoading");
		}
		
		func mapView(_ mapView: MGLMapView, regionDidChangeAnimated animated: Bool) {
			self.parent.zoomLevel = mapView.zoomLevel
		
			self.parent.centerCoordinate = mapView.centerCoordinate
		}

		@objc func onDoubleTapped(gestureRecognizer: UITapGestureRecognizer) {
			guard gestureRecognizer.view != nil else { return }

			// center map
			let screenLocation:CGPoint = gestureRecognizer.location(in: gestureRecognizer.view)
			let coordinates:CLLocationCoordinate2D = map.convert(screenLocation, toCoordinateFrom: map)
		
			map.setCenter(coordinates, animated: true)
			
			UIAccessibility.post(notification: UIAccessibility.Notification.pageScrolled,
								 argument: "");
		}
		
		@objc func onPinched(gestureRecognizer: UIPinchGestureRecognizer) {
			guard gestureRecognizer.view != nil else { return }
			
			if gestureRecognizer.state == .ended && gestureRecognizer.velocity != 0 {
				if gestureRecognizer.velocity > 0 {
					map.setZoomLevel(map.zoomLevel + 1, animated: false)
				} else {
					map.setZoomLevel(map.zoomLevel - 1, animated: false)
				}
			}
		}
		
		@objc func onTouchMove(gestureRecognizer: UIPanGestureRecognizer) {
			guard gestureRecognizer.view != nil else { return }
			
			if (gestureRecognizer.state == .ended) {
				parent.features = []
			} else {
				let point = gestureRecognizer.location(in: map)
				let visibleFeatures = map.visibleFeatures(at: point)

				parent.features = visibleFeatures
			}
		}
		
		@objc func onTwoFingerSwipe(gestureRecognizer: UISwipeGestureRecognizer) {
			guard gestureRecognizer.view != nil else { return }
			
			if (gestureRecognizer.state == .ended) {
				parent.moveMapBySector(to: gestureRecognizer.direction)
			}
		}
	}
}

