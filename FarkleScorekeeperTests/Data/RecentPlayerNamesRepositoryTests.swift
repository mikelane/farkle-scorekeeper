import XCTest

@testable import FarkleScorekeeper

final class RecentPlayerNamesRepositoryTests: XCTestCase {

    private var userDefaults: UserDefaults!
    private var repository: RecentPlayerNamesRepository!

    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "RecentPlayerNamesRepositoryTests")!
        userDefaults.removePersistentDomain(forName: "RecentPlayerNamesRepositoryTests")
        repository = RecentPlayerNamesRepository(userDefaults: userDefaults)
    }

    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "RecentPlayerNamesRepositoryTests")
        userDefaults = nil
        repository = nil
        super.tearDown()
    }

    // MARK: - Load Tests

    func test_load_whenNoSavedNames_returnsEmptyArray() {
        let names = repository.load()

        XCTAssertEqual(names, [])
    }

    func test_load_whenNamesSaved_returnsSavedNames() {
        repository.save(["Alice", "Bob"])

        let names = repository.load()

        XCTAssertEqual(names, ["Alice", "Bob"])
    }

    // MARK: - Save Tests

    func test_save_persistsNamesToUserDefaults() {
        repository.save(["Alice", "Bob", "Charlie"])

        let data = userDefaults.array(forKey: RecentPlayerNamesRepository.storageKey) as? [String]
        XCTAssertEqual(data, ["Alice", "Bob", "Charlie"])
    }

    func test_save_overwritesPreviousNames() {
        repository.save(["Alice", "Bob"])
        repository.save(["Charlie", "Diana"])

        let names = repository.load()
        XCTAssertEqual(names, ["Charlie", "Diana"])
    }

    // MARK: - Storage Key Tests

    func test_storageKey_isCorrectValue() {
        XCTAssertEqual(RecentPlayerNamesRepository.storageKey, "recentPlayerNames")
    }
}
