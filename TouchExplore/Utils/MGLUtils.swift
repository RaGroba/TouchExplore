import Mapbox

struct MGLUtils {
	static func dedupeFeatures(features: [MGLFeature]) -> [MGLFeature] {
		return features.reduce([], {(initial: [MGLFeature], next: MGLFeature) in
			if (initial.contains(where: { (item: MGLFeature) -> Bool in
				NSDictionary(dictionary: item.attributes).isEqual(to: NSDictionary(dictionary: next.attributes) as! [AnyHashable : Any])
			})) {					
				return initial
			}
		
			return initial + [next]
		})
	}
}
