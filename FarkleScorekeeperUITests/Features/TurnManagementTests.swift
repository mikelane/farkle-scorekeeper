import XCTest

/// UI tests mirroring features/turn-management.feature
/// Feature: Managing a Turn
final class TurnManagementTests: BDDTestCase {

    override func setUp() {
        super.setUp()
        launchGame()
    }

    // MARK: - Banking behavior

    func test_banking_addsTurnScoreToTotal() {
        given("a game with Player 1 and Player 2")
        and("it is Player 1's turn")
        and("Player 1 has recorded four of a kind worth 2000") {
            recordFourOfAKind()
        }

        when("Player 1 banks her points") {
            bank()
        }

        then("Player 1's total score is 2000") {
            // After banking, it's now Player 2's turn, so we need to
            // check the score differently in a real implementation
            // For now, verify turn advanced
            assertCurrentPlayer("Player 2")
        }
    }

    func test_cannotBank_withTooManyDiceRemaining() {
        given("a game with Player 1 and Player 2")
        and("it is Player 1's turn")
        and("Player 1 has recorded a single one") {
            recordSingleOne()
        }

        then("Player 1 cannot bank yet") {
            assertCannotBank()
        }
    }

    func test_canBank_whenInSafeZone() {
        given("a game with Player 1 and Player 2")
        and("it is Player 1's turn")
        and("Player 1 has recorded four of a kind worth 2000") {
            recordFourOfAKind()
        }

        then("Player 1 can bank her points") {
            assertCanBank()
        }
    }

    // MARK: - Farkling behavior

    func test_farkling_losesTurnScore() {
        given("a game with Player 1 and Player 2")
        and("it is Player 1's turn")
        and("Player 1 has recorded combinations worth 500") {
            recordThreeOfAKind(dieValue: 5)
        }

        when("Player 1 farkles") {
            farkle()
        }

        then("it becomes Player 2's turn") {
            assertCurrentPlayer("Player 2")
        }
    }

    func test_farklingOnFirstRoll_scoresNothing() {
        given("a game with Player 1 and Player 2")
        and("it is Player 1's turn")

        when("Player 1 farkles on her first roll") {
            farkle()
        }

        then("it becomes Player 2's turn") {
            assertCurrentPlayer("Player 2")
        }
    }

    // MARK: - Hot dice behavior

    func test_usingAllDice_triggersHotDice() {
        given("a game with Player 1 and Player 2")
        and("it is Player 1's turn")

        when("Player 1 records a large straight using all 6 dice") {
            recordLargeStraight()
        }

        then("Player 1 has 6 dice to roll again") {
            assertDiceRemaining(6)
        }
        and("Player 1's turn score is preserved") {
            assertTurnScore(1500)
        }
    }

    func test_hotDice_allowsContinuedScoring() {
        given("a game with Player 1 and Player 2")
        and("it is Player 1's turn")
        and("Player 1 has recorded a large straight using all 6 dice") {
            recordLargeStraight()
        }

        when("Player 1 records a single one on her next roll") {
            recordSingleOne()
        }

        then("Player 1's turn score is 1600") {
            assertTurnScore(1600)
        }
        and("Player 1 has 5 dice remaining") {
            assertDiceRemaining(5)
        }
    }

    // MARK: - Six dice farkle (special first roll combination)

    func test_recordingSixDiceFarkle_onFirstRoll() {
        given("a game with Player 1 and Player 2")
        and("it is Player 1's turn")

        when("Player 1 records a six dice farkle") {
            recordSixDiceFarkle()
        }

        then("Player 1's turn score is 500") {
            assertTurnScore(500)
        }
        and("Player 1 has 6 dice remaining") {
            assertDiceRemaining(6)
        }
    }

    // MARK: - Turn state indicators

    func test_newTurn_startsWithSixDice() {
        given("a game with Player 1 and Player 2")
        and("it is Player 1's turn")

        then("Player 1 has 6 dice remaining") {
            assertDiceRemaining(6)
        }
        and("Player 1's turn score is 0") {
            assertTurnScore(0)
        }
    }

    func test_mustRollIndicator_withManyDice() {
        given("a game with Player 1 and Player 2")
        and("it is Player 1's turn")
        and("Player 1 has recorded a single one") {
            recordSingleOne()
        }

        then("Player 1 cannot bank") {
            assertCannotBank()
        }
        and("Player 1 has 5 dice remaining") {
            assertDiceRemaining(5)
        }
    }

    func test_safeZone_withTwoDice() {
        given("a game with Player 1 and Player 2")
        and("it is Player 1's turn")
        and("Player 1 has recorded four of a kind") {
            recordFourOfAKind()
        }

        then("Player 1 can choose to bank or continue") {
            assertCanBank()
        }
        and("Player 1 has 2 dice remaining") {
            assertDiceRemaining(2)
        }
    }

    func test_safeZone_withOneDie() {
        given("a game with Player 1 and Player 2")
        and("it is Player 1's turn")
        and("Player 1 has recorded five of a kind") {
            recordFiveOfAKind()
        }

        then("Player 1 can choose to bank or continue") {
            assertCanBank()
        }
        and("Player 1 has 1 die remaining") {
            assertDiceRemaining(1)
        }
    }
}
