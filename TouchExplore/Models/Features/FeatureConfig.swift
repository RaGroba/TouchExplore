import Mapbox

protocol FeatureConfigProtocol {
	var name: String { get set }
	
	var includeTypes: [String] { get set }
	
	var onEntered: FeatureFeedback? { get set }
	var onActive: FeatureFeedback? { get set }
	var onLeave: FeatureFeedback? { get set }
}

protocol FeatureFeedbackProtocol {
	var sound: String? { get set }
	var vibration: String? { get set }
	var text:String? { get set }
}

enum GeoJSONFeatureTypes {
	enum Country: String {
		case Country
		case XYZ
	}
}

struct FeatureFeedback: FeatureFeedbackProtocol {
	var sound: String?
	var vibration: String?
	var text:String?
}

class FeatureFeedbackBuilder {
	private var feedback: FeatureFeedback
	
	init() {
		feedback = FeatureFeedback()
	}
	
	func withText(from attribute: String) -> FeatureFeedbackBuilder {
		self.feedback.text = attribute
		
		return self
	}
	
	func withSound(filePath: String?) -> FeatureFeedbackBuilder {
		self.feedback.sound = filePath
		
		return self
	}
	
	func with(vibration: String) -> FeatureFeedbackBuilder {
		self.feedback.vibration = vibration
		
		return self
	}
	
	func build() -> FeatureFeedback {
		return self.feedback
	}
}

class FeatureConfig: FeatureConfigProtocol {
	var name: String
	var includeTypes: [String]
	
	var onEntered: FeatureFeedback?
	var onActive: FeatureFeedback?
	var onLeave: FeatureFeedback?
	
	init(name: String, includeTypes: [String]) {
		self.name = name
		self.includeTypes = includeTypes
	}
	
	func addAction(onEntered: FeatureFeedback) -> FeatureConfig {
		self.onEntered = onEntered
		
		return self
	}
	
	func addAction(onActive: FeatureFeedback) -> FeatureConfig {
		self.onActive = onActive
		
		return self
	}
	
	func addAction(onLeave: FeatureFeedback) -> FeatureConfig {
		self.onLeave = onLeave
		
		return self
	}
}

struct FeatureInteraction: Equatable {
	var feature: MGLFeature
	var config: FeatureConfig

	static func ==(lhs: FeatureInteraction, rhs: FeatureInteraction) -> Bool {
		let hasSameIdentifier: Bool = lhs.feature.attribute(forKey: "identifier") as? String == rhs.feature.attribute(forKey: "identifier") as? String
		let areAttributesEqual: Bool = NSDictionary(dictionary: lhs.feature.attributes) == NSDictionary(dictionary: rhs.feature.attributes)
		
		return hasSameIdentifier && areAttributesEqual
	}
}

struct FeatureMapper {
	/// map feature interactions to generate custom interaction feedback. IncludedTypes should conform the GeoJSON types, name is just for internal usage.
	/// It should have at least one of the provided actions/hooks registered (otherwise it would be useless to add it)
	/// sorted by priority (index 0 -> highest)
	private let types: [FeatureConfig] = [
		// MARK: - Streets
		FeatureConfig(
			name: "streets",
			includeTypes: ["residential", "street", "street_limited", "secondary", "tertiary", "primary", "motorway"]
		).addAction(
			onEntered: FeatureFeedbackBuilder()
				.withText(from: "name")
				.withSound(filePath: Bundle.main.path(forResource: "street", ofType: "mp3"))
				.build()
		),
		// MARK: - Buildings
		FeatureConfig(
			name: "buildings",
			includeTypes:["building","apartments","farm","hotel","house","detached","dormitory","terrace","houseboat","bungalow","cabin","commercial","office","industrial","retail","supermarket","warehouse","kiosk","religious","cathedral","temple","chapel","church","mosque","synagogue","shrine","civic","government","hospital","school","transportation","stadium","train_station","university","grandstand","public","barn","bridge","bunker","carport","conservatory","garage","garages","farm_auxiliary","garbage_shed","greenhouse","hangar","hut","pavilion","parking","roof","sports_hall","shed","stable","service","ruins","transformer_tower","water_tower"]
		).addAction(
			onEntered: FeatureFeedbackBuilder()
				.withSound(filePath: Bundle.main.path(forResource: "door_open", ofType: "wav"))
				.build()
		).addAction(
			onLeave: FeatureFeedbackBuilder()
				.withSound(filePath: Bundle.main.path(forResource: "door_close", ofType: "mp3"))
				.build()
		),
		// MARK: - Forests
		FeatureConfig(
			name: "forests",
			includeTypes: ["forest"]
		).addAction(onActive:
			FeatureFeedbackBuilder()
				.withSound(filePath: Bundle.main.path(forResource: "forest", ofType: "mp3"))
				.build()
		),
		// MARK: - Playgrounds
		FeatureConfig(
			name: "playgrounds",
			includeTypes: ["playground"]
		).addAction(
			onActive: FeatureFeedbackBuilder()
				.withSound(filePath: Bundle.main.path(forResource: "playground", ofType: "mp3"))
				.build()
		),
		// MARK: - Country
		FeatureConfig(
			name: "countries",
			includeTypes: ["Country", "Sovereign country"]
		).addAction(
			onEntered: FeatureFeedbackBuilder().withText(from: "NAME_DE").build()
		)
	]
	
	
//	let stadiumTypes = ["sports_centre","athletics", "soccer"]
//	let tennisTypes = ["tennis"]
//	let golfTypes = ["golf_course", "golf"]
//	let playgroundTypes = ["playground"]
//	let railTypes = ["tram", "train", "rail", "narrow_gauge"]
//	let grassTypes = ["grass", "park", "meadow", "garden", "recreation_ground", "wood"]
//	let riverTypes = ["river", "chanel", "stream", "stream_intermittent", "drain", "ditch"]

	
	/// Loop trough all registered types and check if one of them matches the provided feature type
	///
	/// - Return: FeatureConfig
	func getInteractionConfig(for feature: MGLFeature) -> FeatureConfig? {
		return types.first { (config) -> Bool in
			// ignore case since the type key depends on the geojson data-source
			guard let featureType: String = (feature.attribute(forKey: "type") ?? feature.attribute(forKey: "TYPE")) as? String else { return false }
			
			return config.includeTypes.contains(featureType)
		}
	}
	
	func getInteractions(for features: [MGLFeature]) -> [FeatureInteraction]? {
		return features.compactMap { feature in
			guard let config = getInteractionConfig(for: feature) else { return nil }
			
			return FeatureInteraction(feature: feature, config: config)
		}
	}
	
	func getInteractionWithHighestPriority(for features: [MGLFeature]) -> FeatureInteraction? {
		let interactedFeatures: [FeatureInteraction]? = getInteractions(for: features)
		
//		print("---", interactedFeatures?.first)
		
		return interactedFeatures?.first
	}
}

/**
country:
Feature: ["BRK_DIFF": 0, "ABBREV": Ger., "MAPCOLOR7": 2, "NAME_AR": ألمانيا, "GEOU_DIF": 0, "WB_A2": DE, "MAX_LABEL": 6.7, "SOV_A3": DEU, "WIKIDATAID": Q183, "TYPE": Sovereign country, "POP_RANK": 16, "NAME_ZH": 德国, "SUBREGION": Western Europe, "NAME_ALT": , "GDP_YEAR": 2016, "NAME_TR": Almanya, "NAME_DE": Deutschland, "NAME_PT": Alemanha, "FORMAL_FR": , "LEVEL": 2, "NAME_VI": Đức, "NAME_CIAWF": Germany, "NAME_JA": ドイツ, "NAME_IT": Germania, "SUBUNIT": Germany, "POSTAL": D, "NOTE_ADM0": , "NAME_EN": Germany, "ADM0_A3": DEU, "SU_DIF": 0, "FIPS_10_": GM, "featurecla": Admin-0 country, "NAME_HU": Németország, "WB_A3": DEU, "WOE_ID": 23424829, "NAME_RU": Германия, "TINY": -99, "BRK_A3": DEU, "BRK_NAME": Germany, "ADMIN": Germany, "SOVEREIGNT": Germany, "ISO_A3_EH": DEU, "SU_A3": DEU, "POP_EST": 80594017, "NAME_LEN": 7, "GU_A3": DEU, "NAME_ID": Jerman, "NAME_EL": Γερμανία, "NOTE_BRK": , "LABELRANK": 2, "ADM0_A3_IS": DEU, "WIKIPEDIA": -99, "NAME_BN": জার্মানি, "INCOME_GRP": 1. High income: OECD, "ECONOMY": 1. Developed region: G7, "ADM0_DIF": 0, "MAPCOLOR8": 5, "NAME_FR": Allemagne, "LASTCENSUS": 2011, "MIN_LABEL": 1.7, "ADM0_A3_US": DEU, "MAPCOLOR9": 5, "POP_YEAR": 2017, "GEOUNIT": Germany, "GDP_MD_EST": 3979000, "NAME_NL": Duitsland, "ISO_A3": DEU, "ABBREV_LEN": 4, "NAME_LONG": Germany, "REGION_UN": Europe, "NE_ID": 1159320539, "NAME": Germany, "NAME_SV": Tyskland, "WOE_NOTE": Exact WOE match as country, "NAME_KO": 독일, "LONG_LEN": 7, "ISO_N3": 276, "HOMEPART": 1, "ADM0_A3_WB": -99, "BRK_GROUP": , "NAME_ES": Alemania, "UN_A3": 276, "NAME_HI": जर्मनी, "ADM0_A3_UN": -99, "REGION_WB": Europe & Central Asia, "WOE_ID_EH": 23424829, "FORMAL_EN": Federal Republic of Germany, "NAME_PL": Niemcy, "scalerank": 0, "MAPCOLOR13": 1, "ISO_A2": DE, "MIN_ZOOM": 0, "CONTINENT": Europe, "NAME_SORT": Germany]

*/
