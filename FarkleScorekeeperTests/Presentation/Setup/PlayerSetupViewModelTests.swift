import XCTest

@testable import FarkleScorekeeper

final class PlayerSetupViewModelTests: XCTestCase {

    // MARK: - Initialization Tests

    func test_init_playerCountDefaultsToTwo() {
        let viewModel = PlayerSetupViewModel()

        XCTAssertEqual(viewModel.playerCount, 2)
    }

    func test_init_playerNamesHasCorrectCount() {
        let viewModel = PlayerSetupViewModel()

        XCTAssertEqual(viewModel.playerNames.count, 2)
    }

    func test_init_playerNamesAreEmpty() {
        let viewModel = PlayerSetupViewModel()

        XCTAssertTrue(viewModel.playerNames.allSatisfy { $0.isEmpty })
    }

    // MARK: - Player Count Adjustment Tests

    func test_setPlayerCount_increasingCount_addsEmptyNames() {
        var viewModel = PlayerSetupViewModel()
        viewModel.playerNames[0] = "Alice"
        viewModel.playerNames[1] = "Bob"

        viewModel.playerCount = 3

        XCTAssertEqual(viewModel.playerNames.count, 3)
        XCTAssertEqual(viewModel.playerNames[0], "Alice")
        XCTAssertEqual(viewModel.playerNames[1], "Bob")
        XCTAssertEqual(viewModel.playerNames[2], "")
    }

    func test_setPlayerCount_decreasingCount_removesExtraNames() {
        var viewModel = PlayerSetupViewModel()
        viewModel.playerCount = 3
        viewModel.playerNames[0] = "Alice"
        viewModel.playerNames[1] = "Bob"
        viewModel.playerNames[2] = "Charlie"

        viewModel.playerCount = 2

        XCTAssertEqual(viewModel.playerNames.count, 2)
        XCTAssertEqual(viewModel.playerNames[0], "Alice")
        XCTAssertEqual(viewModel.playerNames[1], "Bob")
    }

    // MARK: - Final Player Names Tests

    func test_finalPlayerNames_withCustomNames_returnsCustomNames() {
        var viewModel = PlayerSetupViewModel()
        viewModel.playerNames[0] = "Alice"
        viewModel.playerNames[1] = "Bob"

        XCTAssertEqual(viewModel.finalPlayerNames, ["Alice", "Bob"])
    }

    func test_finalPlayerNames_withEmptyNames_returnsDefaultNames() {
        let viewModel = PlayerSetupViewModel()

        XCTAssertEqual(viewModel.finalPlayerNames, ["Player 1", "Player 2"])
    }

    func test_finalPlayerNames_withMixedNames_fillsEmptyWithDefaults() {
        var viewModel = PlayerSetupViewModel()
        viewModel.playerNames[0] = "Alice"
        viewModel.playerNames[1] = ""

        XCTAssertEqual(viewModel.finalPlayerNames, ["Alice", "Player 2"])
    }

    func test_finalPlayerNames_trimsWhitespace() {
        var viewModel = PlayerSetupViewModel()
        viewModel.playerNames[0] = "  Alice  "
        viewModel.playerNames[1] = "Bob"

        XCTAssertEqual(viewModel.finalPlayerNames, ["Alice", "Bob"])
    }

    func test_finalPlayerNames_whitespaceOnlyTreatedAsEmpty() {
        var viewModel = PlayerSetupViewModel()
        viewModel.playerNames[0] = "   "
        viewModel.playerNames[1] = "Bob"

        XCTAssertEqual(viewModel.finalPlayerNames, ["Player 1", "Bob"])
    }

    // MARK: - Validation Tests

    func test_canStartGame_allNamesEmpty_returnsTrue() {
        let viewModel = PlayerSetupViewModel()

        XCTAssertTrue(viewModel.canStartGame)
    }

    func test_canStartGame_allNamesProvided_returnsTrue() {
        var viewModel = PlayerSetupViewModel()
        viewModel.playerNames[0] = "Alice"
        viewModel.playerNames[1] = "Bob"

        XCTAssertTrue(viewModel.canStartGame)
    }

    func test_canStartGame_someNamesProvided_returnsFalse() {
        var viewModel = PlayerSetupViewModel()
        viewModel.playerNames[0] = "Alice"
        viewModel.playerNames[1] = ""

        XCTAssertFalse(viewModel.canStartGame)
    }

    func test_canStartGame_whitespaceOnlyCountsAsEmpty() {
        var viewModel = PlayerSetupViewModel()
        viewModel.playerNames[0] = "Alice"
        viewModel.playerNames[1] = "   "

        XCTAssertFalse(viewModel.canStartGame)
    }

    func test_validationMessage_allNamesEmptyOrFilled_isNil() {
        let viewModel = PlayerSetupViewModel()

        XCTAssertNil(viewModel.validationMessage)
    }

    func test_validationMessage_partiallyFilled_returnsMessage() {
        var viewModel = PlayerSetupViewModel()
        viewModel.playerNames[0] = "Alice"
        viewModel.playerNames[1] = ""

        XCTAssertNotNil(viewModel.validationMessage)
    }

    // MARK: - Recent Names Tests

    func test_init_loadsRecentNamesFromRepository() {
        let userDefaults = UserDefaults(suiteName: "PlayerSetupViewModelTests")!
        userDefaults.removePersistentDomain(forName: "PlayerSetupViewModelTests")
        let repository = RecentPlayerNamesRepository(userDefaults: userDefaults)
        repository.save(["Alice", "Bob"])

        let viewModel = PlayerSetupViewModel(recentNamesRepository: repository)

        XCTAssertEqual(viewModel.recentNames, ["Alice", "Bob"])
    }

    func test_saveRecentNames_savesCurrentNamesToRepository() {
        let userDefaults = UserDefaults(suiteName: "PlayerSetupViewModelTests")!
        userDefaults.removePersistentDomain(forName: "PlayerSetupViewModelTests")
        let repository = RecentPlayerNamesRepository(userDefaults: userDefaults)
        var viewModel = PlayerSetupViewModel(recentNamesRepository: repository)
        viewModel.playerNames[0] = "Charlie"
        viewModel.playerNames[1] = "Diana"

        viewModel.saveRecentNames()

        XCTAssertEqual(repository.load(), ["Charlie", "Diana"])
    }

    func test_saveRecentNames_savesTrimmedNames() {
        let userDefaults = UserDefaults(suiteName: "PlayerSetupViewModelTests")!
        userDefaults.removePersistentDomain(forName: "PlayerSetupViewModelTests")
        let repository = RecentPlayerNamesRepository(userDefaults: userDefaults)
        var viewModel = PlayerSetupViewModel(recentNamesRepository: repository)
        viewModel.playerNames[0] = "  Charlie  "
        viewModel.playerNames[1] = "Diana"

        viewModel.saveRecentNames()

        XCTAssertEqual(repository.load(), ["Charlie", "Diana"])
    }

    func test_saveRecentNames_filtersEmptyNames() {
        let userDefaults = UserDefaults(suiteName: "PlayerSetupViewModelTests")!
        userDefaults.removePersistentDomain(forName: "PlayerSetupViewModelTests")
        let repository = RecentPlayerNamesRepository(userDefaults: userDefaults)
        var viewModel = PlayerSetupViewModel(recentNamesRepository: repository)
        viewModel.playerNames[0] = "Charlie"
        viewModel.playerNames[1] = ""

        viewModel.saveRecentNames()

        XCTAssertEqual(repository.load(), ["Charlie"])
    }

    func test_suggestedNames_returnsRecentNames() {
        let userDefaults = UserDefaults(suiteName: "PlayerSetupViewModelTests")!
        userDefaults.removePersistentDomain(forName: "PlayerSetupViewModelTests")
        let repository = RecentPlayerNamesRepository(userDefaults: userDefaults)
        repository.save(["Alice", "Bob", "Charlie"])

        let viewModel = PlayerSetupViewModel(recentNamesRepository: repository)

        XCTAssertEqual(viewModel.suggestedNames, ["Alice", "Bob", "Charlie"])
    }
}
