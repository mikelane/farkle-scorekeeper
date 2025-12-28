import XCTest

@testable import FarkleScorekeeper

final class GameViewModelTests: XCTestCase {

    // MARK: - Initialization Tests

    func test_init_exposesCurrentPlayerName() {
        let viewModel = GameViewModel(playerNames: ["Alice", "Bob"])

        XCTAssertEqual(viewModel.currentPlayerName, "Alice")
    }

    func test_init_turnScoreIsZero() {
        let viewModel = GameViewModel(playerNames: ["Alice"])

        XCTAssertEqual(viewModel.turnScore, 0)
    }

    func test_init_diceRemainingIsSix() {
        let viewModel = GameViewModel(playerNames: ["Alice"])

        XCTAssertEqual(viewModel.diceRemaining, 6)
    }

    // MARK: - Add Score Tests

    func test_addScore_singleOne_increasesTurnScoreBy100() {
        var viewModel = GameViewModel(playerNames: ["Alice"])

        viewModel.addScore(.singleOne)

        XCTAssertEqual(viewModel.turnScore, 100)
    }

    func test_addScore_singleOne_decreasesDiceRemainingByOne() {
        var viewModel = GameViewModel(playerNames: ["Alice"])

        viewModel.addScore(.singleOne)

        XCTAssertEqual(viewModel.diceRemaining, 5)
    }

    func test_addScore_threeOfAKind_decreasesDiceRemainingByThree() {
        var viewModel = GameViewModel(playerNames: ["Alice"])

        viewModel.addScore(.threeOfAKind(dieValue: 3))

        XCTAssertEqual(viewModel.diceRemaining, 3)
    }

    // MARK: - Bank Tests

    func test_canBank_withSixDice_isFalse() {
        let viewModel = GameViewModel(playerNames: ["Alice"])

        XCTAssertFalse(viewModel.canBank)
    }

    func test_canBank_withTwoDice_isTrue() {
        var viewModel = GameViewModel(playerNames: ["Alice"])
        viewModel.addScore(.fourOfAKind)

        XCTAssertTrue(viewModel.canBank)
    }

    func test_bank_addsScoreToPlayerTotal() {
        var viewModel = GameViewModel(playerNames: ["Alice"])
        viewModel.addScore(.fourOfAKind)

        let banked = viewModel.bank()

        XCTAssertTrue(banked)
        XCTAssertEqual(viewModel.currentPlayerScore, 2000)
    }

    // MARK: - Farkle Tests

    func test_farkle_advancesToNextPlayer() {
        var viewModel = GameViewModel(playerNames: ["Alice", "Bob"])

        viewModel.farkle()

        XCTAssertEqual(viewModel.currentPlayerName, "Bob")
    }

    func test_farkle_resetsTurnScore() {
        var viewModel = GameViewModel(playerNames: ["Alice"])
        viewModel.addScore(.singleOne)

        viewModel.farkle()

        XCTAssertEqual(viewModel.turnScore, 0)
    }

    // MARK: - Must Roll Tests

    func test_mustRoll_withSixDice_isTrue() {
        let viewModel = GameViewModel(playerNames: ["Alice"])

        XCTAssertTrue(viewModel.mustRoll)
    }

    func test_mustRoll_withThreeDice_isTrue() {
        var viewModel = GameViewModel(playerNames: ["Alice"])
        viewModel.addScore(.threeOfAKind(dieValue: 2))

        XCTAssertTrue(viewModel.mustRoll)
    }

    func test_mustRoll_withTwoDice_isFalse() {
        var viewModel = GameViewModel(playerNames: ["Alice"])
        viewModel.addScore(.fourOfAKind)

        XCTAssertFalse(viewModel.mustRoll)
    }

    // MARK: - Available Combinations Tests

    func test_isCombinationAvailable_singleOne_withOneDie_isTrue() {
        var viewModel = GameViewModel(playerNames: ["Alice"])
        viewModel.addScore(.fiveOfAKind)

        XCTAssertTrue(viewModel.isCombinationAvailable(.singleOne))
    }

    func test_isCombinationAvailable_threeOfAKind_withTwoDice_isFalse() {
        var viewModel = GameViewModel(playerNames: ["Alice"])
        viewModel.addScore(.fourOfAKind)

        XCTAssertFalse(viewModel.isCombinationAvailable(.threeOfAKind(dieValue: 3)))
    }

    func test_isCombinationAvailable_sixDiceFarkle_onFirstRoll_isTrue() {
        let viewModel = GameViewModel(playerNames: ["Alice"])

        XCTAssertTrue(viewModel.isCombinationAvailable(.sixDiceFarkle))
    }

    func test_isCombinationAvailable_sixDiceFarkle_afterScoring_isFalse() {
        var viewModel = GameViewModel(playerNames: ["Alice"])
        viewModel.addScore(.singleOne)

        XCTAssertFalse(viewModel.isCombinationAvailable(.sixDiceFarkle))
    }

    func test_isCombinationAvailable_singleOne_afterAddingSingleFive_isTrue() {
        var viewModel = GameViewModel(playerNames: ["Alice"])
        viewModel.addScore(.singleFive)  // Uses 1 die, leaves 5

        XCTAssertTrue(viewModel.isCombinationAvailable(.singleOne))
    }

    func test_isCombinationAvailable_threeOfAKind_afterAddingSingleOne_isTrue() {
        var viewModel = GameViewModel(playerNames: ["Alice"])
        viewModel.addScore(.singleOne)  // Uses 1 die, leaves 5

        XCTAssertTrue(viewModel.isCombinationAvailable(.threeOfAKind(dieValue: 2)))
    }

    // MARK: - Game State Tests

    func test_isGameOver_initiallyFalse() {
        let viewModel = GameViewModel(playerNames: ["Alice"])

        XCTAssertFalse(viewModel.isGameOver)
    }

    func test_winnerName_whenNoWinner_isNil() {
        let viewModel = GameViewModel(playerNames: ["Alice"])

        XCTAssertNil(viewModel.winnerName)
    }
}
