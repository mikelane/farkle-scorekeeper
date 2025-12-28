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
}
