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

    func test_bankPoints_triggersFinaRound_whenPlayerReachesTargetScore() {
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
}
