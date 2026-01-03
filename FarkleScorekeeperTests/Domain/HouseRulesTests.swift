import XCTest

@testable import FarkleScorekeeper

final class HouseRulesTests: XCTestCase {

    // MARK: - Default Values Tests

    func test_default_targetScoreIsTenThousand() {
        let rules = HouseRules()

        XCTAssertEqual(rules.targetScore, 10000)
    }

    func test_default_finalRoundEnabledIsTrue() {
        let rules = HouseRules()

        XCTAssertTrue(rules.finalRoundEnabled)
    }

    func test_default_defendYourWinIsFalse() {
        let rules = HouseRules()

        XCTAssertFalse(rules.defendYourWin)
    }

    // MARK: - Custom Values Tests

    func test_init_acceptsCustomTargetScore() {
        let rules = HouseRules(targetScore: 5000)

        XCTAssertEqual(rules.targetScore, 5000)
    }

    func test_init_acceptsFinalRoundDisabled() {
        let rules = HouseRules(finalRoundEnabled: false)

        XCTAssertFalse(rules.finalRoundEnabled)
    }

    func test_init_acceptsDefendYourWinEnabled() {
        let rules = HouseRules(defendYourWin: true)

        XCTAssertTrue(rules.defendYourWin)
    }

    func test_init_acceptsAllCustomValues() {
        let rules = HouseRules(
            targetScore: 7500,
            finalRoundEnabled: false,
            defendYourWin: true
        )

        XCTAssertEqual(rules.targetScore, 7500)
        XCTAssertFalse(rules.finalRoundEnabled)
        XCTAssertTrue(rules.defendYourWin)
    }

    // MARK: - Preset Target Scores

    func test_presetTargetScores_containsExpectedValues() {
        let presets = HouseRules.presetTargetScores

        XCTAssertEqual(presets, [5000, 7500, 10000, 15000])
    }

    // MARK: - Equatable Tests

    func test_twoDefaultRules_areEqual() {
        let rules1 = HouseRules()
        let rules2 = HouseRules()

        XCTAssertEqual(rules1, rules2)
    }

    func test_rulesWithDifferentTargetScore_areNotEqual() {
        let rules1 = HouseRules(targetScore: 10000)
        let rules2 = HouseRules(targetScore: 5000)

        XCTAssertNotEqual(rules1, rules2)
    }

    func test_rulesWithDifferentFinalRoundEnabled_areNotEqual() {
        let rules1 = HouseRules(finalRoundEnabled: true)
        let rules2 = HouseRules(finalRoundEnabled: false)

        XCTAssertNotEqual(rules1, rules2)
    }

    func test_rulesWithDifferentDefendYourWin_areNotEqual() {
        let rules1 = HouseRules(defendYourWin: true)
        let rules2 = HouseRules(defendYourWin: false)

        XCTAssertNotEqual(rules1, rules2)
    }

    // MARK: - Codable Tests

    func test_encodesAndDecodesToJSON() throws {
        let original = HouseRules(
            targetScore: 7500,
            finalRoundEnabled: false,
            defendYourWin: true
        )

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(HouseRules.self, from: data)

        XCTAssertEqual(decoded, original)
    }

    func test_decodesFromJSONWithMissingFields_usesDefaults() throws {
        let json = "{}"
        let data = json.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(HouseRules.self, from: data)

        XCTAssertEqual(decoded.targetScore, 10000)
        XCTAssertTrue(decoded.finalRoundEnabled)
        XCTAssertFalse(decoded.defendYourWin)
    }

    // MARK: - ScoringConfig Tests

    func test_default_scoringConfigIsStandard() {
        let rules = HouseRules()

        XCTAssertEqual(rules.scoringConfig, ScoringConfig.standard)
    }

    func test_init_acceptsCustomScoringConfig() {
        var customConfig = ScoringConfig.standard
        customConfig.setEnabled(false, for: .threePairs)
        let rules = HouseRules(scoringConfig: customConfig)

        XCTAssertFalse(rules.scoringConfig.isEnabled(.threePairs))
    }

    func test_rulesWithDifferentScoringConfig_areNotEqual() {
        var customConfig = ScoringConfig.standard
        customConfig.setEnabled(false, for: .threePairs)
        let rules1 = HouseRules()
        let rules2 = HouseRules(scoringConfig: customConfig)

        XCTAssertNotEqual(rules1, rules2)
    }

    func test_encodesAndDecodesWithScoringConfig() throws {
        var customConfig = ScoringConfig.standard
        customConfig.setEnabled(false, for: .threePairs)
        customConfig.setCustomPoints(1000, for: .fourOfAKind)
        let original = HouseRules(scoringConfig: customConfig)

        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(HouseRules.self, from: data)

        XCTAssertEqual(decoded.scoringConfig, customConfig)
    }

    func test_decodesFromJSONWithMissingScoringConfig_usesStandard() throws {
        let json = "{\"targetScore\": 5000}"
        let data = json.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(HouseRules.self, from: data)

        XCTAssertEqual(decoded.scoringConfig, ScoringConfig.standard)
    }
}
