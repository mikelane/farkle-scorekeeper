import XCTest

@testable import FarkleScorekeeper

final class ScoringConfigTests: XCTestCase {

    // MARK: - Default Configuration Tests

    func test_standard_hasAllCombinationsEnabled() {
        let config = ScoringConfig.standard

        for combinationType in ScoringCombinationType.allCases {
            XCTAssertTrue(
                config.isEnabled(combinationType),
                "\(combinationType) should be enabled by default"
            )
        }
    }

    func test_standard_hasNoCustomPoints() {
        let config = ScoringConfig.standard

        XCTAssertTrue(config.customPoints.isEmpty)
    }

    func test_standard_hasDefaultThreeOfAKindMultiplier() {
        let config = ScoringConfig.standard

        XCTAssertEqual(config.threeOfAKindMultiplier, 100)
    }

    // MARK: - Enabling/Disabling Combinations Tests

    func test_disabling_aCombination_removesItFromEnabledSet() {
        var config = ScoringConfig.standard
        config.setEnabled(false, for: .threePairs)

        XCTAssertFalse(config.isEnabled(.threePairs))
    }

    func test_enabling_aPreviouslyDisabledCombination_addsItToEnabledSet() {
        var config = ScoringConfig.standard
        config.setEnabled(false, for: .threePairs)
        config.setEnabled(true, for: .threePairs)

        XCTAssertTrue(config.isEnabled(.threePairs))
    }

    func test_disabling_multipleCombinations_removesAllFromEnabledSet() {
        var config = ScoringConfig.standard
        config.setEnabled(false, for: .threePairs)
        config.setEnabled(false, for: .sixDiceFarkle)

        XCTAssertFalse(config.isEnabled(.threePairs))
        XCTAssertFalse(config.isEnabled(.sixDiceFarkle))
        XCTAssertTrue(config.isEnabled(.singleOne))
    }

    // MARK: - Custom Point Values Tests

    func test_settingCustomPoints_storesTheValue() {
        var config = ScoringConfig.standard
        config.setCustomPoints(1000, for: .fourOfAKind)

        XCTAssertEqual(config.customPoints[.fourOfAKind], 1000)
    }

    func test_clearingCustomPoints_removesTheValue() {
        var config = ScoringConfig.standard
        config.setCustomPoints(1000, for: .fourOfAKind)
        config.clearCustomPoints(for: .fourOfAKind)

        XCTAssertNil(config.customPoints[.fourOfAKind])
    }

    // MARK: - Three of a Kind Multiplier Tests

    func test_settingThreeOfAKindMultiplier_storesTheValue() {
        var config = ScoringConfig.standard
        config.threeOfAKindMultiplier = 50

        XCTAssertEqual(config.threeOfAKindMultiplier, 50)
    }

    // MARK: - Reset to Standard Tests

    func test_resetToStandard_resetsAllCombinationsToEnabled() {
        var config = ScoringConfig.standard
        config.setEnabled(false, for: .threePairs)
        config.setEnabled(false, for: .sixDiceFarkle)
        config.resetToStandard()

        for combinationType in ScoringCombinationType.allCases {
            XCTAssertTrue(config.isEnabled(combinationType))
        }
    }

    func test_resetToStandard_clearsAllCustomPoints() {
        var config = ScoringConfig.standard
        config.setCustomPoints(1000, for: .fourOfAKind)
        config.setCustomPoints(50, for: .singleOne)
        config.resetToStandard()

        XCTAssertTrue(config.customPoints.isEmpty)
    }

    func test_resetToStandard_resetsThreeOfAKindMultiplier() {
        var config = ScoringConfig.standard
        config.threeOfAKindMultiplier = 50
        config.resetToStandard()

        XCTAssertEqual(config.threeOfAKindMultiplier, 100)
    }

    // MARK: - Codable Tests

    func test_encodesAndDecodesToJSON() throws {
        var original = ScoringConfig.standard
        original.setEnabled(false, for: .threePairs)
        original.setCustomPoints(1000, for: .fourOfAKind)
        original.threeOfAKindMultiplier = 50

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(ScoringConfig.self, from: data)

        XCTAssertFalse(decoded.isEnabled(.threePairs))
        XCTAssertEqual(decoded.customPoints[.fourOfAKind], 1000)
        XCTAssertEqual(decoded.threeOfAKindMultiplier, 50)
    }

    func test_decodesFromEmptyJSON_usesDefaults() throws {
        let json = "{}"
        let data = json.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(ScoringConfig.self, from: data)

        for combinationType in ScoringCombinationType.allCases {
            XCTAssertTrue(decoded.isEnabled(combinationType))
        }
        XCTAssertTrue(decoded.customPoints.isEmpty)
        XCTAssertEqual(decoded.threeOfAKindMultiplier, 100)
    }

    // MARK: - Equatable Tests

    func test_twoStandardConfigs_areEqual() {
        let config1 = ScoringConfig.standard
        let config2 = ScoringConfig.standard

        XCTAssertEqual(config1, config2)
    }

    func test_configsWithDifferentEnabledCombinations_areNotEqual() {
        let config1 = ScoringConfig.standard
        var config2 = ScoringConfig.standard
        config2.setEnabled(false, for: .threePairs)

        XCTAssertNotEqual(config1, config2)
    }
}
