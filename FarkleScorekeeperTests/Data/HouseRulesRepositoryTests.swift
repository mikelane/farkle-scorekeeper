import XCTest

@testable import FarkleScorekeeper

final class HouseRulesRepositoryTests: XCTestCase {

    private var userDefaults: UserDefaults!
    private var repository: HouseRulesRepository!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "HouseRulesRepositoryTests")!
        userDefaults.removePersistentDomain(forName: "HouseRulesRepositoryTests")
        repository = HouseRulesRepository(userDefaults: userDefaults)
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "HouseRulesRepositoryTests")
        userDefaults = nil
        repository = nil
        super.tearDown()
    }

    // MARK: - Load Tests

    func test_load_whenNoSavedRules_returnsDefaultRules() {
        let rules = repository.load()

        XCTAssertEqual(rules, HouseRules())
    }

    func test_load_whenRulesSaved_returnsSavedRules() {
        let customRules = HouseRules(
            targetScore: 7500,
            finalRoundEnabled: false,
            defendYourWin: true
        )
        repository.save(customRules)

        let loadedRules = repository.load()

        XCTAssertEqual(loadedRules, customRules)
    }

    // MARK: - Save Tests

    func test_save_persistsRulesToUserDefaults() {
        let customRules = HouseRules(
            targetScore: 5000,
            finalRoundEnabled: true,
            defendYourWin: true
        )

        repository.save(customRules)

        let data = userDefaults.data(forKey: HouseRulesRepository.storageKey)
        XCTAssertNotNil(data)
    }

    func test_save_overwritesPreviousRules() {
        let firstRules = HouseRules(targetScore: 5000)
        let secondRules = HouseRules(targetScore: 15000)

        repository.save(firstRules)
        repository.save(secondRules)

        let loadedRules = repository.load()
        XCTAssertEqual(loadedRules.targetScore, 15000)
    }

    // MARK: - Reset Tests

    func test_reset_clearsStoredRules() {
        let customRules = HouseRules(targetScore: 5000)
        repository.save(customRules)

        repository.reset()

        let data = userDefaults.data(forKey: HouseRulesRepository.storageKey)
        XCTAssertNil(data)
    }

    func test_reset_causesLoadToReturnDefaults() {
        let customRules = HouseRules(targetScore: 5000)
        repository.save(customRules)

        repository.reset()
        let loadedRules = repository.load()

        XCTAssertEqual(loadedRules, HouseRules())
    }

    // MARK: - Storage Key Tests

    func test_storageKey_isCorrectValue() {
        XCTAssertEqual(HouseRulesRepository.storageKey, "houseRules")
    }
}
