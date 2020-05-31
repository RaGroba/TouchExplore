import Mapbox

extension MGLFeature {
	/// compare features by attributes
	static func ==(lhs: Self, rhs: Self) -> Bool {
		return NSDictionary(dictionary: lhs.attributes) == NSDictionary(dictionary: rhs.attributes)
	}
}
