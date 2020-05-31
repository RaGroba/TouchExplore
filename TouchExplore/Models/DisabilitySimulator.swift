import Foundation

struct DisabilitySimulator {
	var blur: Double
	var blindness: Double
	var grayscale: Double
	var contrast: Double
	
	init(blur: Double? = nil, blindness: Double? = nil, grayscale: Double? = nil, contrast: Double? = nil) {
		self.blur = blur ?? 0
		self.blindness = blindness ?? 0
		self.grayscale = grayscale ?? 0
		self.contrast = contrast ?? 1
	}
	
	mutating func reset() {
		self = DisabilitySimulator()
	}
}
