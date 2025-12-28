import XCTest

@testable import FarkleScorekeeper

final class GameTests: XCTestCase {

    // MARK: - Initialization Tests

    func test_init_createsPlayersFromNames() {
        let game = Game(playerNames: ["Alice", "Bob"])

        XCTAssertEqual(game.players.count, 2)
        XCTAssertEqual(game.players[0].name, "Alice")
        XCTAssertEqual(game.players[1].name, "Bob")
    }

    func test_init_defaultTargetScoreIsTenThousand() {
        let game = Game(playerNames: ["Alice"])

        XCTAssertEqual(game.targetScore, 10000)
    }

    func test_init_customTargetScore() {
        let game = Game(playerNames: ["Alice"], targetScore: 5000)

        XCTAssertEqual(game.targetScore, 5000)
    }

    func test_init_currentPlayerIndexIsZero() {
        let game = Game(playerNames: ["Alice", "Bob"])

        XCTAssertEqual(game.currentPlayerIndex, 0)
    }

    func test_init_isGameOverIsFalse() {
        let game = Game(playerNames: ["Alice"])

        XCTAssertFalse(game.isGameOver)
    }

    func test_init_winnerIsNil() {
        let game = Game(playerNames: ["Alice"])

        XCTAssertNil(game.winner)
    }

    func test_init_currentTurnIsNewTurn() {
        let game = Game(playerNames: ["Alice"])

        XCTAssertEqual(game.currentTurn.score, 0)
        XCTAssertEqual(game.currentTurn.diceRemaining, 6)
    }

    // MARK: - currentPlayer Tests

    func test_currentPlayer_returnsFirstPlayerInitially() {
        let game = Game(playerNames: ["Alice", "Bob"])

        XCTAssertEqual(game.currentPlayer.name, "Alice")
    }

    // MARK: - addScore Tests

    func test_addScore_updatesTurnScore() {
        var game = Game(playerNames: ["Alice"])

        game.addScore(.singleOne)

        XCTAssertEqual(game.currentTurn.score, 100)
    }

    func test_addScore_updatesTurnDiceRemaining() {
        var game = Game(playerNames: ["Alice"])

        game.addScore(.singleOne)

        XCTAssertEqual(game.currentTurn.diceRemaining, 5)
    }

    // MARK: - bankPoints Tests

    func test_bankPoints_whenCanBank_returnsTrueAndAddsScoreToPlayer() {
        var game = Game(playerNames: ["Alice", "Bob"])
        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)

        let result = game.bankPoints()

        XCTAssertTrue(result)
        XCTAssertEqual(game.players[0].score, 450)
    }

    func test_bankPoints_whenCanBank_advancesToNextPlayer() {
        var game = Game(playerNames: ["Alice", "Bob"])
        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)

        _ = game.bankPoints()

        XCTAssertEqual(game.currentPlayerIndex, 1)
        XCTAssertEqual(game.currentPlayer.name, "Bob")
    }

    func test_bankPoints_whenCanBank_resetsCurrentTurn() {
        var game = Game(playerNames: ["Alice", "Bob"])
        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)

        _ = game.bankPoints()

        XCTAssertEqual(game.currentTurn.score, 0)
        XCTAssertEqual(game.currentTurn.diceRemaining, 6)
    }

    func test_bankPoints_whenCannotBank_returnsFalse() {
        var game = Game(playerNames: ["Alice"])
        game.addScore(.singleOne)

        let result = game.bankPoints()

        XCTAssertFalse(result)
    }

    func test_bankPoints_whenCannotBank_doesNotChangeScore() {
        var game = Game(playerNames: ["Alice"])
        game.addScore(.singleOne)

        _ = game.bankPoints()

        XCTAssertEqual(game.players[0].score, 0)
    }

    func test_bankPoints_playerRotationWrapsAroundToFirstPlayer() {
        var game = Game(playerNames: ["Alice", "Bob"])
        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()
        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)

        _ = game.bankPoints()

        XCTAssertEqual(game.currentPlayerIndex, 0)
        XCTAssertEqual(game.currentPlayer.name, "Alice")
    }

    // MARK: - farkle Tests

    func test_farkle_advancesToNextPlayer() {
        var game = Game(playerNames: ["Alice", "Bob"])
        game.addScore(.singleOne)

        game.farkle()

        XCTAssertEqual(game.currentPlayerIndex, 1)
        XCTAssertEqual(game.currentPlayer.name, "Bob")
    }

    func test_farkle_doesNotAddTurnScoreToPlayer() {
        var game = Game(playerNames: ["Alice", "Bob"])
        game.addScore(.singleOne)

        game.farkle()

        XCTAssertEqual(game.players[0].score, 0)
    }

    func test_farkle_resetsCurrentTurn() {
        var game = Game(playerNames: ["Alice", "Bob"])
        game.addScore(.singleOne)

        game.farkle()

        XCTAssertEqual(game.currentTurn.score, 0)
        XCTAssertEqual(game.currentTurn.diceRemaining, 6)
    }

    // MARK: - Final Round Tests

    func test_isInFinalRound_initiallyFalse() {
        let game = Game(playerNames: ["Alice", "Bob"])

        XCTAssertFalse(game.isInFinalRound)
    }

    func test_bankPoints_triggersFinalRound_whenPlayerReachesTargetScore() {
        var game = Game(playerNames: ["Alice", "Bob"], targetScore: 1000)
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)

        _ = game.bankPoints()

        XCTAssertTrue(game.isInFinalRound)
    }

    func test_bankPoints_inFinalRound_endsGameWhenReturningToTriggeringPlayer() {
        var game = Game(playerNames: ["Alice", "Bob"], targetScore: 1000)
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()
        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)

        _ = game.bankPoints()

        XCTAssertTrue(game.isGameOver)
    }

    func test_gameOver_winnerIsPlayerWithHighestScore() {
        var game = Game(playerNames: ["Alice", "Bob"], targetScore: 1000)
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()
        game.addScore(.fourOfAKind)
        game.addScore(.singleOne)

        _ = game.bankPoints()

        XCTAssertEqual(game.winner?.name, "Bob")
    }

    // MARK: - Instant Win Tests

    func test_declareInstantWin_endsGameImmediately() {
        var game = Game(playerNames: ["Alice", "Bob"])

        game.declareInstantWin()

        XCTAssertTrue(game.isGameOver)
    }

    func test_declareInstantWin_setsCurrentPlayerAsWinner() {
        var game = Game(playerNames: ["Alice", "Bob"])

        game.declareInstantWin()

        XCTAssertEqual(game.winner?.name, "Alice")
    }

    func test_declareInstantWin_bypassesFinalRound() {
        var game = Game(playerNames: ["Alice", "Bob"])

        game.declareInstantWin()

        XCTAssertFalse(game.isInFinalRound)
    }

    // MARK: - HouseRules Tests

    func test_init_withHouseRules_usesTargetScoreFromRules() {
        let rules = HouseRules(targetScore: 7500)
        let game = Game(playerNames: ["Alice"], houseRules: rules)

        XCTAssertEqual(game.targetScore, 7500)
    }

    func test_init_withHouseRules_storesHouseRules() {
        let rules = HouseRules(
            targetScore: 5000,
            finalRoundEnabled: false,
            defendYourWin: true
        )
        let game = Game(playerNames: ["Alice"], houseRules: rules)

        XCTAssertEqual(game.houseRules, rules)
    }

    func test_init_withDefaultHouseRules_usesDefaultTargetScore() {
        let game = Game(playerNames: ["Alice"], houseRules: HouseRules())

        XCTAssertEqual(game.targetScore, 10000)
    }

    func test_init_withoutHouseRules_usesDefaultHouseRules() {
        let game = Game(playerNames: ["Alice"])

        XCTAssertEqual(game.houseRules, HouseRules())
    }

    // MARK: - Final Round Disabled Tests

    func test_bankPoints_whenFinalRoundDisabled_endsGameImmediatelyOnReachingTarget() {
        let rules = HouseRules(targetScore: 1000, finalRoundEnabled: false)
        var game = Game(playerNames: ["Alice", "Bob"], houseRules: rules)
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)

        _ = game.bankPoints()

        XCTAssertTrue(game.isGameOver)
        XCTAssertEqual(game.winner?.name, "Alice")
    }

    func test_bankPoints_whenFinalRoundDisabled_doesNotTriggerFinalRound() {
        let rules = HouseRules(targetScore: 1000, finalRoundEnabled: false)
        var game = Game(playerNames: ["Alice", "Bob"], houseRules: rules)
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)

        _ = game.bankPoints()

        XCTAssertFalse(game.isInFinalRound)
    }

    func test_bankPoints_whenFinalRoundEnabled_triggersStandardFinalRound() {
        let rules = HouseRules(targetScore: 1000, finalRoundEnabled: true)
        var game = Game(playerNames: ["Alice", "Bob"], houseRules: rules)
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)

        _ = game.bankPoints()

        XCTAssertTrue(game.isInFinalRound)
        XCTAssertFalse(game.isGameOver)
    }

    func test_bankPoints_exactlyReachingTargetScore_triggersFinalRound() {
        var game = Game(playerNames: ["Alice", "Bob"], targetScore: 450)
        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)

        _ = game.bankPoints()

        XCTAssertTrue(game.isInFinalRound)
        XCTAssertEqual(game.players[0].score, 450)
    }

    // MARK: - Three Player Final Round Tests

    func test_threePlayerGame_allOtherPlayersGetOneFinalTurn() {
        var game = Game(playerNames: ["Alice", "Bob", "Charlie"], targetScore: 450)
        XCTAssertEqual(game.currentPlayerIndex, 0, "Alice starts")

        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        XCTAssertTrue(game.isInFinalRound, "Final round should have started")
        XCTAssertEqual(game.currentPlayerIndex, 1, "Bob's turn")
        XCTAssertEqual(game.currentPlayer.name, "Bob")
        XCTAssertFalse(game.isGameOver, "Game should not be over after Alice banks")

        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        XCTAssertEqual(game.currentPlayerIndex, 2, "Charlie's turn")
        XCTAssertEqual(game.currentPlayer.name, "Charlie")
        XCTAssertFalse(game.isGameOver, "Game should not be over after Bob banks")

        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        XCTAssertTrue(game.isGameOver, "Game should be over after Charlie banks")
    }

    func test_triggerPlayerDoesNotGetAnotherTurn() {
        var game = Game(playerNames: ["Alice", "Bob", "Charlie"], targetScore: 450)
        var aliceTurnCount = 0

        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()
        aliceTurnCount += 1

        while !game.isGameOver {
            if game.currentPlayer.name == "Alice" {
                aliceTurnCount += 1
            }
            game.addScore(.threeOfAKind(dieValue: 3))
            game.addScore(.singleOne)
            game.addScore(.singleFive)
            _ = game.bankPoints()
        }

        XCTAssertEqual(aliceTurnCount, 1)
    }

    func test_farkle_inFinalRound_stillAdvancesAndEndsGame() {
        var game = Game(playerNames: ["Alice", "Bob", "Charlie"], targetScore: 450)

        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        XCTAssertTrue(game.isInFinalRound)

        game.farkle()
        XCTAssertEqual(game.currentPlayer.name, "Charlie")
        XCTAssertFalse(game.isGameOver)

        game.farkle()
        XCTAssertTrue(game.isGameOver)
    }

    func test_highestScoreWins_afterFinalRound_withThreePlayers() {
        var game = Game(playerNames: ["Alice", "Bob", "Charlie"], targetScore: 450)

        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        game.addScore(.fourOfAKind)
        game.addScore(.singleOne)
        _ = game.bankPoints()

        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        XCTAssertEqual(game.winner?.name, "Bob")
        XCTAssertEqual(game.players[0].score, 450)
        XCTAssertEqual(game.players[1].score, 2100)
        XCTAssertEqual(game.players[2].score, 450)
    }

    // MARK: - FinalRoundState Tests

    func test_finalRoundState_initiallyNotStarted() {
        let game = Game(playerNames: ["Alice", "Bob"])

        XCTAssertEqual(game.finalRoundState, .notStarted)
    }

    func test_finalRoundState_inProgress_afterTrigger() {
        var game = Game(playerNames: ["Alice", "Bob", "Charlie"], targetScore: 450)
        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        XCTAssertEqual(game.finalRoundState, .inProgress(triggerPlayerIndex: 0))
    }

    func test_finalRoundState_completed_afterGameEnds() {
        var game = Game(playerNames: ["Alice", "Bob"], targetScore: 450)
        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()
        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        XCTAssertEqual(game.finalRoundState, .completed)
    }
}
