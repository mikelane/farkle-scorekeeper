import XCTest

@testable import FarkleScorekeeper

final class TurnTests: XCTestCase {

    // MARK: - Initial State Tests

    func test_newTurn_hasZeroScore() {
        let turn = Turn()

        XCTAssertEqual(turn.score, 0)
    }

    func test_newTurn_hasSixDiceRemaining() {
        let turn = Turn()

        XCTAssertEqual(turn.diceRemaining, 6)
    }

    func test_newTurn_isFirstRoll() {
        let turn = Turn()

        XCTAssertTrue(turn.isFirstRoll)
    }

    // MARK: - canBank Tests

    func test_canBank_withSixDice_isFalse() {
        let turn = Turn()

        XCTAssertFalse(turn.canBank)
    }

    func test_canBank_withTwoDice_isTrue() {
        var turn = Turn()
        turn.diceRemaining = 2

        XCTAssertTrue(turn.canBank)
    }

    func test_canBank_withOneDie_isTrue() {
        var turn = Turn()
        turn.diceRemaining = 1

        XCTAssertTrue(turn.canBank)
    }

    func test_canBank_withZeroDice_isFalse() {
        var turn = Turn()
        turn.diceRemaining = 0

        XCTAssertFalse(turn.canBank)
    }

    func test_canBank_withThreeDice_isFalse() {
        var turn = Turn()
        turn.diceRemaining = 3

        XCTAssertFalse(turn.canBank)
    }

    // MARK: - mustRoll Tests

    func test_mustRoll_withSixDice_isTrue() {
        let turn = Turn()

        XCTAssertTrue(turn.mustRoll)
    }

    func test_mustRoll_withZeroDice_isTrue() {
        var turn = Turn()
        turn.diceRemaining = 0

        XCTAssertTrue(turn.mustRoll)
    }

    func test_mustRoll_withThreeDice_isTrue() {
        var turn = Turn()
        turn.diceRemaining = 3

        XCTAssertTrue(turn.mustRoll)
    }

    func test_mustRoll_withTwoDice_isFalse() {
        var turn = Turn()
        turn.diceRemaining = 2

        XCTAssertFalse(turn.mustRoll)
    }

    func test_mustRoll_withOneDie_isFalse() {
        var turn = Turn()
        turn.diceRemaining = 1

        XCTAssertFalse(turn.mustRoll)
    }

    // MARK: - addScore Tests

    func test_addScore_addsCombinationPointsToScore() {
        var turn = Turn()

        turn.addScore(.singleOne)

        XCTAssertEqual(turn.score, 100)
    }

    func test_addScore_decrementsDiceRemaining() {
        var turn = Turn()

        turn.addScore(.singleOne)

        XCTAssertEqual(turn.diceRemaining, 5)
    }

    func test_addScore_setsIsFirstRollToFalse() {
        var turn = Turn()

        turn.addScore(.singleOne)

        XCTAssertFalse(turn.isFirstRoll)
    }

    func test_addScore_accumulatesMultipleCombinations() {
        var turn = Turn()

        turn.addScore(.singleOne)
        turn.addScore(.singleFive)

        XCTAssertEqual(turn.score, 150)
        XCTAssertEqual(turn.diceRemaining, 4)
    }

    // MARK: - farkle Tests

    func test_farkle_resetsScoreToZero() {
        var turn = Turn()
        turn.addScore(.singleOne)

        turn.farkle()

        XCTAssertEqual(turn.score, 0)
    }

    // MARK: - hotDice Tests

    func test_hotDice_resetsDiceToSix() {
        var turn = Turn()
        turn.addScore(.largeStraight)

        turn.hotDice()

        XCTAssertEqual(turn.diceRemaining, 6)
    }

    func test_hotDice_keepsAccumulatedScore() {
        var turn = Turn()
        turn.addScore(.largeStraight)

        turn.hotDice()

        XCTAssertEqual(turn.score, 1500)
    }

    // MARK: - scoringHistory Tests

    func test_newTurn_hasEmptyScoringHistory() {
        let turn = Turn()

        XCTAssertTrue(turn.scoringHistory.isEmpty)
    }

    func test_addScore_appendsToScoringHistory() {
        var turn = Turn()

        turn.addScore(.singleOne)
        turn.addScore(.singleFive)

        XCTAssertEqual(turn.scoringHistory.count, 2)
    }
}
