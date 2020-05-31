import Mapbox

struct MGLUtils {
	/// compares features by attributes
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
	
	/// checks wether the features are equal compared by its attributes
	static func featuresAreEqual(feature1: MGLFeature?, feature2: MGLFeature?) -> Bool {
		if feature1?.attributes.count != feature2?.attributes.count {
			return false
		}
			
		// compare features by its attributes
		return NSDictionary(dictionary: feature1!.attributes) == NSDictionary(dictionary: feature2!.attributes)
	}

	static func areFeaturesArrayEqual(lhs: [MGLFeature], rhs: [MGLFeature]) -> Bool {
		if lhs.count != rhs.count {
			return false
		}
		
		if lhs.count == 0 && rhs.count == 0 {
			return true
		}
		
		return lhs.elementsEqual(rhs, by: {
			MGLUtils.featuresAreEqual(feature1: $0, feature2: $1)
		})
	}
}
