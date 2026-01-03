import XCTest

@testable import FarkleScorekeeper

final class HouseRulesViewModelTests: XCTestCase {

    private var userDefaults: UserDefaults!
    private var repository: HouseRulesRepository!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "HouseRulesViewModelTests")!
        userDefaults.removePersistentDomain(forName: "HouseRulesViewModelTests")
        repository = HouseRulesRepository(userDefaults: userDefaults)
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "HouseRulesViewModelTests")
        userDefaults = nil
        repository = nil
        super.tearDown()
    }

    // MARK: - Initialization Tests

    func test_init_loadsTargetScoreFromRepository() {
        let savedRules = HouseRules(targetScore: 7500)
        repository.save(savedRules)

        let viewModel = HouseRulesViewModel(repository: repository)

        XCTAssertEqual(viewModel.targetScore, 7500)
    }

    func test_init_loadsFinalRoundEnabledFromRepository() {
        let savedRules = HouseRules(finalRoundEnabled: false)
        repository.save(savedRules)

        let viewModel = HouseRulesViewModel(repository: repository)

        XCTAssertFalse(viewModel.finalRoundEnabled)
    }

    func test_init_loadsDefendYourWinFromRepository() {
        let savedRules = HouseRules(defendYourWin: true)
        repository.save(savedRules)

        let viewModel = HouseRulesViewModel(repository: repository)

        XCTAssertTrue(viewModel.defendYourWin)
    }

    func test_init_withNoSavedRules_usesDefaults() {
        let viewModel = HouseRulesViewModel(repository: repository)

        XCTAssertEqual(viewModel.targetScore, 10000)
        XCTAssertTrue(viewModel.finalRoundEnabled)
        XCTAssertFalse(viewModel.defendYourWin)
    }

    // MARK: - Saving Tests

    func test_setTargetScore_savesToRepository() {
        let viewModel = HouseRulesViewModel(repository: repository)

        viewModel.targetScore = 5000

        let savedRules = repository.load()
        XCTAssertEqual(savedRules.targetScore, 5000)
    }

    func test_setFinalRoundEnabled_savesToRepository() {
        let viewModel = HouseRulesViewModel(repository: repository)

        viewModel.finalRoundEnabled = false

        let savedRules = repository.load()
        XCTAssertFalse(savedRules.finalRoundEnabled)
    }

    func test_setDefendYourWin_savesToRepository() {
        let viewModel = HouseRulesViewModel(repository: repository)

        viewModel.defendYourWin = true

        let savedRules = repository.load()
        XCTAssertTrue(savedRules.defendYourWin)
    }

    // MARK: - Preset Target Scores Tests

    func test_presetTargetScores_matchesHouseRulesPresets() {
        let viewModel = HouseRulesViewModel(repository: repository)

        XCTAssertEqual(viewModel.presetTargetScores, HouseRules.presetTargetScores)
    }

    // MARK: - Scoring Config Tests

    func test_init_loadsScoringConfigFromRepository() {
        var scoringConfig = ScoringConfig.standard
        scoringConfig.setEnabled(false, for: .threePairs)
        let savedRules = HouseRules(scoringConfig: scoringConfig)
        repository.save(savedRules)

        let viewModel = HouseRulesViewModel(repository: repository)

        XCTAssertFalse(viewModel.isCombinationEnabled(.threePairs))
    }

    func test_init_withNoSavedRules_allCombinationsEnabled() {
        let viewModel = HouseRulesViewModel(repository: repository)

        for combinationType in ScoringCombinationType.allCases {
            XCTAssertTrue(viewModel.isCombinationEnabled(combinationType))
        }
    }

    func test_setCombinationEnabled_savesToRepository() {
        let viewModel = HouseRulesViewModel(repository: repository)

        viewModel.setCombinationEnabled(false, for: .threePairs)

        let savedRules = repository.load()
        XCTAssertFalse(savedRules.scoringConfig.isEnabled(.threePairs))
    }

    func test_customPoints_forCombinationWithNoCustomValue_returnsNil() {
        let viewModel = HouseRulesViewModel(repository: repository)

        XCTAssertNil(viewModel.customPoints(for: .fourOfAKind))
    }

    func test_customPoints_forCombinationWithCustomValue_returnsValue() {
        var scoringConfig = ScoringConfig.standard
        scoringConfig.setCustomPoints(1000, for: .fourOfAKind)
        let savedRules = HouseRules(scoringConfig: scoringConfig)
        repository.save(savedRules)

        let viewModel = HouseRulesViewModel(repository: repository)

        XCTAssertEqual(viewModel.customPoints(for: .fourOfAKind), 1000)
    }

    func test_setCustomPoints_savesToRepository() {
        let viewModel = HouseRulesViewModel(repository: repository)

        viewModel.setCustomPoints(1000, for: .fourOfAKind)

        let savedRules = repository.load()
        XCTAssertEqual(savedRules.scoringConfig.customPoints[.fourOfAKind], 1000)
    }

    func test_clearCustomPoints_savesToRepository() {
        var scoringConfig = ScoringConfig.standard
        scoringConfig.setCustomPoints(1000, for: .fourOfAKind)
        let savedRules = HouseRules(scoringConfig: scoringConfig)
        repository.save(savedRules)
        let viewModel = HouseRulesViewModel(repository: repository)

        viewModel.clearCustomPoints(for: .fourOfAKind)

        let newSavedRules = repository.load()
        XCTAssertNil(newSavedRules.scoringConfig.customPoints[.fourOfAKind])
    }

    func test_threeOfAKindMultiplier_loadsFromRepository() {
        var scoringConfig = ScoringConfig.standard
        scoringConfig.threeOfAKindMultiplier = 50
        let savedRules = HouseRules(scoringConfig: scoringConfig)
        repository.save(savedRules)

        let viewModel = HouseRulesViewModel(repository: repository)

        XCTAssertEqual(viewModel.threeOfAKindMultiplier, 50)
    }

    func test_setThreeOfAKindMultiplier_savesToRepository() {
        let viewModel = HouseRulesViewModel(repository: repository)

        viewModel.threeOfAKindMultiplier = 50

        let savedRules = repository.load()
        XCTAssertEqual(savedRules.scoringConfig.threeOfAKindMultiplier, 50)
    }

    func test_resetScoringConfigToStandard_resetsAllValues() {
        var scoringConfig = ScoringConfig.standard
        scoringConfig.setEnabled(false, for: .threePairs)
        scoringConfig.setCustomPoints(1000, for: .fourOfAKind)
        scoringConfig.threeOfAKindMultiplier = 50
        let savedRules = HouseRules(scoringConfig: scoringConfig)
        repository.save(savedRules)
        let viewModel = HouseRulesViewModel(repository: repository)

        viewModel.resetScoringConfigToStandard()

        let newSavedRules = repository.load()
        XCTAssertTrue(newSavedRules.scoringConfig.isEnabled(.threePairs))
        XCTAssertTrue(newSavedRules.scoringConfig.customPoints.isEmpty)
        XCTAssertEqual(newSavedRules.scoringConfig.threeOfAKindMultiplier, 100)
    }
}
