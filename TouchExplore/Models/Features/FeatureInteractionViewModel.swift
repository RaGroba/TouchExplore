import SwiftUI
import Combine
import Mapbox

final class FeatureInteractionViewModel: ObservableObject {
	private let featureService = FeatureMapper()
	
	@Published var featureInteractions: [FeatureInteraction]?

	@Published var features: [MGLFeature]? {
		didSet {
			print(features)
		}
	}
	
	init() {
		print("init")
	}
	
	@Published var currentValue: FeatureInteraction? {
		willSet {
			var event: Event?
			
			if currentValue == nil && newValue != nil {
				// first interaction
				print("first interaction")
			} else if currentValue != nil && newValue == nil {
				// last interaction
				print("last interaction")
			} else if currentValue == newValue {
				// interaction on same
				print("is active")
			} else {
				// feature did change
				print("did change")
			}
		}
	}
	
	@Published private(set) var state = State.idle

	static func reduce(_ state: State, _ event: Event) -> State {
		switch state {
			case .idle:
				switch event {
					case .onEntered:
						return .entered
					default:
						return state
				}
			case .entered:
				switch event {
					case .onUpdated:
						return .active
					case .onEnded:
						return .ended
					default:
						return state
				}
			case .active:
				switch event {
					case .onEnded:
						return .ended
					default:
						return state
				}
			case .ended:
				switch event {
					case .onDestroyed:
						return .idle
					default:
						return state
			}
			default:
				return state
		}
	}
}

extension FeatureInteractionViewModel {
	enum State {
		case idle
		case entered
		case active
		case ended
	}
	
	enum Event {
		case onEntered
		case onUpdated
		case onEnded
		case onDestroyed
	}
}
