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

    // MARK: - Turn Scoring History Tests

    func test_turnScoringHistory_initiallyEmpty() {
        let viewModel = GameViewModel(playerNames: ["Alice"])

        XCTAssertTrue(viewModel.turnScoringHistory.isEmpty)
    }

    func test_turnScoringHistory_afterSingleOne_containsSingleOne() {
        var viewModel = GameViewModel(playerNames: ["Alice"])

        viewModel.addScore(.singleOne)

        XCTAssertEqual(viewModel.turnScoringHistory.count, 1)
        XCTAssertEqual(viewModel.turnScoringHistory.first, .singleOne)
    }

    func test_turnScoringHistory_afterMultipleCombinations_containsAllInOrder() {
        var viewModel = GameViewModel(playerNames: ["Alice"])

        viewModel.addScore(.singleOne)
        viewModel.addScore(.singleFive)

        XCTAssertEqual(viewModel.turnScoringHistory.count, 2)
        XCTAssertEqual(viewModel.turnScoringHistory[0], .singleOne)
        XCTAssertEqual(viewModel.turnScoringHistory[1], .singleFive)
    }

    func test_turnScoringHistory_afterFarkle_clearsForNextPlayer() {
        var viewModel = GameViewModel(playerNames: ["Alice", "Bob"])
        viewModel.addScore(.singleOne)

        viewModel.farkle()

        XCTAssertTrue(viewModel.turnScoringHistory.isEmpty)
    }

    func test_turnScoringHistory_afterBank_clearsForNextPlayer() {
        var viewModel = GameViewModel(playerNames: ["Alice", "Bob"])
        viewModel.addScore(.fourOfAKind)

        viewModel.bank()

        XCTAssertTrue(viewModel.turnScoringHistory.isEmpty)
    }

    // MARK: - Undo Tests

    func test_canUndo_atStartOfTurn_isFalse() {
        let viewModel = GameViewModel(playerNames: ["Alice"])

        XCTAssertFalse(viewModel.canUndo)
    }

    func test_canUndo_afterAddingScore_isTrue() {
        var viewModel = GameViewModel(playerNames: ["Alice"])
        viewModel.addScore(.singleOne)

        XCTAssertTrue(viewModel.canUndo)
    }

    func test_canUndo_afterFarkle_isFalse() {
        var viewModel = GameViewModel(playerNames: ["Alice", "Bob"])
        viewModel.addScore(.singleOne)
        viewModel.farkle()

        XCTAssertFalse(viewModel.canUndo)
    }

    func test_canUndo_afterBanking_isFalse() {
        var viewModel = GameViewModel(playerNames: ["Alice", "Bob"])
        viewModel.addScore(.fourOfAKind)
        viewModel.bank()

        XCTAssertFalse(viewModel.canUndo)
    }

    func test_undo_restoresTurnScore() {
        var viewModel = GameViewModel(playerNames: ["Alice"])
        viewModel.addScore(.singleOne)

        viewModel.undo()

        XCTAssertEqual(viewModel.turnScore, 0)
    }

    func test_undo_restoresDiceRemaining() {
        var viewModel = GameViewModel(playerNames: ["Alice"])
        viewModel.addScore(.singleOne)

        viewModel.undo()

        XCTAssertEqual(viewModel.diceRemaining, 6)
    }

    func test_undo_removesFromScoringHistory() {
        var viewModel = GameViewModel(playerNames: ["Alice"])
        viewModel.addScore(.singleOne)

        viewModel.undo()

        XCTAssertTrue(viewModel.turnScoringHistory.isEmpty)
    }

    func test_undo_afterMultipleScores_restoresLastState() {
        var viewModel = GameViewModel(playerNames: ["Alice"])
        viewModel.addScore(.singleOne)
        viewModel.addScore(.singleFive)

        viewModel.undo()

        XCTAssertEqual(viewModel.turnScore, 100)
        XCTAssertEqual(viewModel.diceRemaining, 5)
    }

    func test_undo_restoresSixDiceFarkleAvailability() {
        var viewModel = GameViewModel(playerNames: ["Alice"])
        viewModel.addScore(.singleOne)

        XCTAssertFalse(viewModel.isCombinationAvailable(.sixDiceFarkle))

        viewModel.undo()

        XCTAssertTrue(viewModel.isCombinationAvailable(.sixDiceFarkle))
    }

    // MARK: - Final Round UI Tests

    func test_isInFinalRound_initiallyFalse() {
        let viewModel = GameViewModel(playerNames: ["Alice", "Bob"])

        XCTAssertFalse(viewModel.isInFinalRound)
    }

    func test_finalRoundTriggerPlayerName_initiallyNil() {
        let viewModel = GameViewModel(playerNames: ["Alice", "Bob"])

        XCTAssertNil(viewModel.finalRoundTriggerPlayerName)
    }

    func test_isInFinalRound_afterPlayerReachesTarget_isTrue() {
        let houseRules = HouseRules(targetScore: 2000, finalRoundEnabled: true)
        var viewModel = GameViewModel(playerNames: ["Alice", "Bob"], houseRules: houseRules)
        viewModel.addScore(.fourOfAKind) // 2000 points

        viewModel.bank()

        XCTAssertTrue(viewModel.isInFinalRound)
    }

    func test_finalRoundTriggerPlayerName_afterPlayerReachesTarget_returnsPlayerName() {
        let houseRules = HouseRules(targetScore: 2000, finalRoundEnabled: true)
        var viewModel = GameViewModel(playerNames: ["Alice", "Bob"], houseRules: houseRules)
        viewModel.addScore(.fourOfAKind) // 2000 points

        viewModel.bank()

        XCTAssertEqual(viewModel.finalRoundTriggerPlayerName, "Alice")
    }

    func test_targetScore_returnsHouseRulesTarget() {
        let houseRules = HouseRules(targetScore: 7500, finalRoundEnabled: true)
        let viewModel = GameViewModel(playerNames: ["Alice", "Bob"], houseRules: houseRules)

        XCTAssertEqual(viewModel.targetScore, 7500)
    }

    func test_currentPlayerFinalRoundStatus_beforeFinalRound_isNormal() {
        let viewModel = GameViewModel(playerNames: ["Alice", "Bob"])

        XCTAssertEqual(viewModel.currentPlayerFinalRoundStatus, .normal)
    }

    func test_currentPlayerFinalRoundStatus_forChallenger_isChallenger() {
        let houseRules = HouseRules(targetScore: 2000, finalRoundEnabled: true)
        var viewModel = GameViewModel(playerNames: ["Alice", "Bob"], houseRules: houseRules)
        viewModel.addScore(.fourOfAKind) // 2000 points - Alice triggers final round
        viewModel.bank() // Alice banks, now Bob's turn (challenger)

        XCTAssertEqual(viewModel.currentPlayerFinalRoundStatus, .challenger)
    }

    func test_currentPlayerFinalRoundStatus_forSecondChallenger_isChallenger() {
        let houseRules = HouseRules(targetScore: 2000, finalRoundEnabled: true)
        var viewModel = GameViewModel(playerNames: ["Alice", "Bob", "Charlie"], houseRules: houseRules)
        viewModel.addScore(.fourOfAKind) // 2000 points - Alice triggers final round
        viewModel.bank() // Alice banks, now Bob's turn (challenger)
        viewModel.farkle() // Bob farkles, now Charlie's turn (also challenger)

        XCTAssertEqual(viewModel.currentPlayerFinalRoundStatus, .challenger)
    }

    func test_scoreToBeat_beforeFinalRound_isNil() {
        let viewModel = GameViewModel(playerNames: ["Alice", "Bob"])

        XCTAssertNil(viewModel.scoreToBeat)
    }

    func test_scoreToBeat_inFinalRound_returnsTriggerPlayerScore() {
        let houseRules = HouseRules(targetScore: 2000, finalRoundEnabled: true)
        var viewModel = GameViewModel(playerNames: ["Alice", "Bob"], houseRules: houseRules)
        viewModel.addScore(.fourOfAKind) // 2000 points - Alice triggers final round
        viewModel.bank() // Alice banks with 2000, now Bob's turn

        XCTAssertEqual(viewModel.scoreToBeat, 2000)
    }

    func test_playersInfo_returnsAllPlayers() {
        let viewModel = GameViewModel(playerNames: ["Alice", "Bob", "Charlie"])

        XCTAssertEqual(viewModel.playersInfo.count, 3)
        XCTAssertEqual(viewModel.playersInfo[0].name, "Alice")
        XCTAssertEqual(viewModel.playersInfo[1].name, "Bob")
        XCTAssertEqual(viewModel.playersInfo[2].name, "Charlie")
    }

    func test_playersInfo_showsCorrectScores() {
        let houseRules = HouseRules(targetScore: 10000, finalRoundEnabled: true)
        var viewModel = GameViewModel(playerNames: ["Alice", "Bob"], houseRules: houseRules)
        viewModel.addScore(.fourOfAKind) // 2000 points
        viewModel.bank() // Alice has 2000

        XCTAssertEqual(viewModel.playersInfo[0].score, 2000)
        XCTAssertEqual(viewModel.playersInfo[1].score, 0)
    }

    func test_playersInfo_beforeFinalRound_allStatusNormal() {
        let viewModel = GameViewModel(playerNames: ["Alice", "Bob"])

        XCTAssertEqual(viewModel.playersInfo[0].status, .normal)
        XCTAssertEqual(viewModel.playersInfo[1].status, .normal)
    }

    func test_playersInfo_inFinalRound_defenderShowsDefending() {
        let houseRules = HouseRules(targetScore: 2000, finalRoundEnabled: true)
        var viewModel = GameViewModel(playerNames: ["Alice", "Bob"], houseRules: houseRules)
        viewModel.addScore(.fourOfAKind) // 2000 points - Alice triggers final round
        viewModel.bank() // Alice banks, now Bob's turn

        XCTAssertEqual(viewModel.playersInfo[0].status, .defending)
        XCTAssertEqual(viewModel.playersInfo[1].status, .challenger)
    }

    func test_playersInfo_showsCurrentPlayer() {
        var viewModel = GameViewModel(playerNames: ["Alice", "Bob"])

        XCTAssertTrue(viewModel.playersInfo[0].isCurrentPlayer)
        XCTAssertFalse(viewModel.playersInfo[1].isCurrentPlayer)

        viewModel.farkle() // Advance to Bob

        XCTAssertFalse(viewModel.playersInfo[0].isCurrentPlayer)
        XCTAssertTrue(viewModel.playersInfo[1].isCurrentPlayer)
    }
}
