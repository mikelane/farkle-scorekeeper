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

    // MARK: - Defend Your Win Tests

    func test_defendYourWin_playerBeatsLeader_becomesNewDefender() {
        // Given: Alice triggered the final round with 10200 points
        // Bob is playing and banks enough to reach 10500 points
        // Then: Bob becomes the new leader and must defend
        let rules = HouseRules(targetScore: 1000, finalRoundEnabled: true, defendYourWin: true)
        var game = Game(playerNames: ["Alice", "Bob", "Charlie"], houseRules: rules)

        // Alice gets 1150 points (triggers final round)
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        XCTAssertTrue(game.isInFinalRound)
        XCTAssertEqual(game.currentDefenderIndex, 0, "Alice should be initial defender")

        // Bob gets 2100 points (beats Alice)
        game.addScore(.fourOfAKind)
        game.addScore(.singleOne)
        _ = game.bankPoints()

        XCTAssertEqual(game.currentDefenderIndex, 1, "Bob should be new defender")
        XCTAssertFalse(game.isGameOver, "Game should continue for defense round")
    }

    func test_defendYourWin_previousLeaderGetsChanceToReclaim() {
        // Given: Bob beat Alice with higher score
        // When it becomes Alice's turn
        // Then Alice has one turn to beat Bob
        let rules = HouseRules(targetScore: 1000, finalRoundEnabled: true, defendYourWin: true)
        var game = Game(playerNames: ["Alice", "Bob", "Charlie"], houseRules: rules)

        // Alice triggers final round with 1150
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        // Bob beats Alice with 2100
        game.addScore(.fourOfAKind)
        game.addScore(.singleOne)
        _ = game.bankPoints()

        XCTAssertEqual(game.currentDefenderIndex, 1, "Bob should be defender")
        XCTAssertEqual(game.currentPlayerIndex, 2, "Charlie is next")

        // Charlie doesn't beat Bob (scores only 450)
        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        // Now Alice (previous leader) gets a chance to reclaim
        XCTAssertEqual(game.currentPlayer.name, "Alice")
        XCTAssertFalse(game.isGameOver, "Alice should get a turn to beat Bob")
    }

    func test_defendYourWin_chainOfOvertakes() {
        // Given: Bob beat Alice, then Charlie beats Bob
        // Then: Charlie must defend, Alice and Bob get turns to beat Charlie
        let rules = HouseRules(targetScore: 1000, finalRoundEnabled: true, defendYourWin: true)
        var game = Game(playerNames: ["Alice", "Bob", "Charlie"], houseRules: rules)

        // Alice triggers final round with 1150
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        // Bob beats Alice with 2100
        game.addScore(.fourOfAKind)
        game.addScore(.singleOne)
        _ = game.bankPoints()

        XCTAssertEqual(game.currentDefenderIndex, 1, "Bob should be defender")

        // Charlie beats Bob with 3000
        game.addScore(.fiveOfAKind)
        _ = game.bankPoints()

        XCTAssertEqual(game.currentDefenderIndex, 2, "Charlie should be new defender")
        XCTAssertFalse(game.isGameOver, "Alice and Bob should get turns")
    }

    func test_defendYourWin_defenderWinsWhenAllChallengersFail() {
        // Given: Alice is defending with score
        // When: Bob and Charlie bank but don't beat Alice
        // Then: Alice wins the game
        let rules = HouseRules(targetScore: 1000, finalRoundEnabled: true, defendYourWin: true)
        var game = Game(playerNames: ["Alice", "Bob", "Charlie"], houseRules: rules)

        // Alice triggers and defends with 1150
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        // Bob scores 450 (doesn't beat Alice)
        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        XCTAssertFalse(game.isGameOver, "Game continues - Charlie hasn't played")

        // Charlie scores 450 (doesn't beat Alice)
        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        XCTAssertTrue(game.isGameOver, "Game should end - all challengers failed")
        XCTAssertEqual(game.winner?.name, "Alice", "Alice should win as defender")
    }

    func test_defendYourWin_defenderWinsWhenAllChallengersFarkle() {
        // Given: Alice is defending
        // When: Bob farkles and Charlie farkles
        // Then: Alice wins the game
        let rules = HouseRules(targetScore: 1000, finalRoundEnabled: true, defendYourWin: true)
        var game = Game(playerNames: ["Alice", "Bob", "Charlie"], houseRules: rules)

        // Alice triggers and defends with 1150
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        // Bob farkles
        game.farkle()

        XCTAssertFalse(game.isGameOver, "Game continues - Charlie hasn't played")

        // Charlie farkles
        game.farkle()

        XCTAssertTrue(game.isGameOver, "Game should end - all challengers farkled")
        XCTAssertEqual(game.winner?.name, "Alice", "Alice should win as defender")
    }

    func test_defendYourWin_farkledPlayerEliminatedFromDefenseRounds() {
        // Given: Alice triggers, Bob farkles, Charlie beats Alice
        // Then: Only Alice gets turn to beat Charlie (Bob eliminated)
        let rules = HouseRules(targetScore: 1000, finalRoundEnabled: true, defendYourWin: true)
        var game = Game(playerNames: ["Alice", "Bob", "Charlie"], houseRules: rules)

        // Alice triggers with 1150
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        XCTAssertEqual(game.currentDefenderIndex, 0, "Alice is defender")

        // Bob farkles (eliminated)
        game.farkle()

        XCTAssertTrue(game.eliminatedPlayerIndices.contains(1), "Bob should be eliminated")
        XCTAssertEqual(game.currentPlayer.name, "Charlie")

        // Charlie beats Alice with 3000
        game.addScore(.fiveOfAKind)
        _ = game.bankPoints()

        XCTAssertEqual(game.currentDefenderIndex, 2, "Charlie is new defender")
        // Alice should get turn, Bob (eliminated) should be skipped
        XCTAssertEqual(game.currentPlayer.name, "Alice", "Should be Alice's turn, Bob skipped")
        XCTAssertFalse(game.isGameOver, "Game should continue")

        // Alice fails to beat Charlie
        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        // Should end - all non-eliminated players had their turn
        XCTAssertTrue(game.isGameOver, "Game should end")
        XCTAssertEqual(game.winner?.name, "Charlie", "Charlie should win")
    }

    func test_defendYourWin_eliminatedPlayersSkipped() {
        // Verify that eliminated players are skipped in the turn order
        let rules = HouseRules(targetScore: 1000, finalRoundEnabled: true, defendYourWin: true)
        var game = Game(playerNames: ["Alice", "Bob", "Charlie"], houseRules: rules)

        // Alice triggers with 1150
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        // Bob farkles (eliminated)
        game.farkle()

        XCTAssertTrue(game.eliminatedPlayerIndices.contains(1), "Bob should be eliminated")
        XCTAssertEqual(game.currentPlayer.name, "Charlie", "Should skip to Charlie")

        // Charlie beats Alice
        game.addScore(.fourOfAKind)
        game.addScore(.singleOne)
        _ = game.bankPoints()

        XCTAssertEqual(game.currentDefenderIndex, 2, "Charlie is defender")
        // Alice should get a turn, but Bob (eliminated) should be skipped
        XCTAssertEqual(game.currentPlayer.name, "Alice", "Should be Alice's turn, Bob skipped")
    }

    // MARK: - Issue #54: Two-Player Defend Your Win Semantics

    func test_defendYourWin_twoPlayer_challengerFarkles_defenderWins() {
        // Test Case 1: P1 triggers → P2 farkles → P1 wins
        let rules = HouseRules(targetScore: 1000, finalRoundEnabled: true, defendYourWin: true)
        var game = Game(playerNames: ["Alice", "Bob"], houseRules: rules)

        // Alice triggers final round with 1150
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        XCTAssertTrue(game.isInFinalRound)
        XCTAssertEqual(game.currentDefenderIndex, 0)
        XCTAssertEqual(game.currentPlayer.name, "Bob")

        // Bob farkles
        game.farkle()

        XCTAssertTrue(game.isGameOver, "Game should end when challenger farkles")
        XCTAssertEqual(game.winner?.name, "Alice", "Defender Alice should win")
    }

    func test_defendYourWin_twoPlayer_challengerOvertakes_defenderFarkles_challengerWins() {
        // Test Case 2: P1 triggers → P2 passes P1 → P1 farkles → P2 wins
        let rules = HouseRules(targetScore: 1000, finalRoundEnabled: true, defendYourWin: true)
        var game = Game(playerNames: ["Alice", "Bob"], houseRules: rules)

        // Alice triggers final round with 1150
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        XCTAssertEqual(game.currentDefenderIndex, 0)

        // Bob overtakes with 2100
        game.addScore(.fourOfAKind)
        game.addScore(.singleOne)
        _ = game.bankPoints()

        XCTAssertEqual(game.currentDefenderIndex, 1, "Bob should now be defender")
        XCTAssertFalse(game.isGameOver, "Game should NOT end - Alice gets a chance")
        XCTAssertEqual(game.currentPlayer.name, "Alice", "Alice should get a turn to respond")

        // Alice farkles
        game.farkle()

        XCTAssertTrue(game.isGameOver, "Game should end when Alice farkles")
        XCTAssertEqual(game.winner?.name, "Bob", "Bob should win")
    }

    func test_defendYourWin_twoPlayer_backAndForth_secondChallengerFarkles() {
        // Test Case 3: P1 triggers → P2 passes P1 → P1 passes P2 → P2 farkles → P1 wins
        let rules = HouseRules(targetScore: 1000, finalRoundEnabled: true, defendYourWin: true)
        var game = Game(playerNames: ["Alice", "Bob"], houseRules: rules)

        // Alice triggers with 1150
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        // Bob overtakes with 2100
        game.addScore(.fourOfAKind)
        game.addScore(.singleOne)
        _ = game.bankPoints()

        XCTAssertEqual(game.currentDefenderIndex, 1, "Bob is defender")
        XCTAssertEqual(game.currentPlayer.name, "Alice")

        // Alice overtakes Bob with 5000 (her total is now 1150 + 3000 = 4150, but Bob has 2100)
        // Let's make Alice pass Bob: she needs >2100 total, so >950 this turn
        // Actually let's give her 3000 points to clearly overtake
        game.addScore(.fiveOfAKind)
        _ = game.bankPoints()

        // Alice now has 1150 + 3000 = 4150, Bob has 2100
        XCTAssertEqual(game.currentDefenderIndex, 0, "Alice should now be defender again")
        XCTAssertFalse(game.isGameOver, "Game continues - Bob gets a chance")
        XCTAssertEqual(game.currentPlayer.name, "Bob")

        // Bob farkles
        game.farkle()

        XCTAssertTrue(game.isGameOver, "Game should end when Bob farkles")
        XCTAssertEqual(game.winner?.name, "Alice", "Alice should win")
    }

    func test_defendYourWin_twoPlayer_multipleOvertakes_originalChallengerFarkles() {
        // Test Case 4: P1 triggers → P2 passes P1 → P1 passes P2 → P2 passes P1 → P1 farkles → P2 wins
        let rules = HouseRules(targetScore: 1000, finalRoundEnabled: true, defendYourWin: true)
        var game = Game(playerNames: ["Alice", "Bob"], houseRules: rules)

        // Alice triggers with 1150
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        // Bob overtakes with 2100 (total: 2100)
        game.addScore(.fourOfAKind)
        game.addScore(.singleOne)
        _ = game.bankPoints()

        XCTAssertEqual(game.currentDefenderIndex, 1)

        // Alice overtakes with 3000 (total: 4150)
        game.addScore(.fiveOfAKind)
        _ = game.bankPoints()

        XCTAssertEqual(game.currentDefenderIndex, 0)

        // Bob overtakes with 3000 (total: 5100)
        game.addScore(.fiveOfAKind)
        _ = game.bankPoints()

        XCTAssertEqual(game.currentDefenderIndex, 1, "Bob is defender again")
        XCTAssertEqual(game.currentPlayer.name, "Alice")

        // Alice farkles
        game.farkle()

        XCTAssertTrue(game.isGameOver, "Game should end when Alice farkles")
        XCTAssertEqual(game.winner?.name, "Bob", "Bob should win")
    }

    func test_defendYourWin_twoPlayer_challengerBanksButDoesntPass_defenderWins() {
        // Test Case 5: P1 triggers → P2 banks but doesn't pass P1 → P1 wins
        let rules = HouseRules(targetScore: 1000, finalRoundEnabled: true, defendYourWin: true)
        var game = Game(playerNames: ["Alice", "Bob"], houseRules: rules)

        // Alice triggers with 1150
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        XCTAssertEqual(game.currentDefenderIndex, 0)

        // Bob scores 450 (doesn't beat Alice's 1150)
        game.addScore(.threeOfAKind(dieValue: 3))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        XCTAssertTrue(game.isGameOver, "Game should end - Bob failed to overtake")
        XCTAssertEqual(game.winner?.name, "Alice", "Alice should win as defender")
    }

    func test_defendYourWin_gameDoesNotEndImmediatelyWhenChallengerOvertakes() {
        // Specific regression test for Issue #54 bug
        // Bug: Game ended immediately when P2 overtook P1, instead of giving P1 a chance
        let rules = HouseRules(targetScore: 1000, finalRoundEnabled: true, defendYourWin: true)
        var game = Game(playerNames: ["Alice", "Bob"], houseRules: rules)

        // Alice triggers with 1150
        game.addScore(.threeOfAKind(dieValue: 1))
        game.addScore(.singleOne)
        game.addScore(.singleFive)
        _ = game.bankPoints()

        XCTAssertTrue(game.isInFinalRound)
        XCTAssertEqual(game.currentDefenderIndex, 0, "Alice is defender")

        // Bob overtakes with 2100
        game.addScore(.fourOfAKind)
        game.addScore(.singleOne)
        _ = game.bankPoints()

        // CRITICAL: This is the bug scenario - game should NOT end here
        XCTAssertFalse(game.isGameOver, "BUG CHECK: Game must NOT end when challenger overtakes")
        XCTAssertNil(game.winner, "BUG CHECK: No winner yet - defender must get a response turn")
        XCTAssertEqual(game.currentDefenderIndex, 1, "Bob is new defender")
        XCTAssertEqual(game.currentPlayer.name, "Alice", "Alice must get a turn to respond")
    }
}
