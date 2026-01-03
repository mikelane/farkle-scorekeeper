import XCTest

@testable import FarkleScorekeeper

final class ScoringCombinationTests: XCTestCase {

    // MARK: - Single Dice Tests

    func test_singleOne_isWorth100Points() {
        let combination = ScoringCombination.singleOne

        XCTAssertEqual(combination.points, 100)
    }

    func test_singleFive_isWorth50Points() {
        let combination = ScoringCombination.singleFive

        XCTAssertEqual(combination.points, 50)
    }

    // MARK: - Dice Count Tests

    func test_singleOne_uses1Die() {
        let combination = ScoringCombination.singleOne

        XCTAssertEqual(combination.diceCount, 1)
    }

    func test_singleFive_uses1Die() {
        let combination = ScoringCombination.singleFive

        XCTAssertEqual(combination.diceCount, 1)
    }

    func test_threeOfAKind_uses3Dice() {
        let combination = ScoringCombination.threeOfAKind(dieValue: 2)

        XCTAssertEqual(combination.diceCount, 3)
    }

    func test_fourOfAKind_uses4Dice() {
        let combination = ScoringCombination.fourOfAKind

        XCTAssertEqual(combination.diceCount, 4)
    }

    func test_fiveOfAKind_uses5Dice() {
        let combination = ScoringCombination.fiveOfAKind

        XCTAssertEqual(combination.diceCount, 5)
    }

    func test_sixOfAKind_uses6Dice() {
        let combination = ScoringCombination.sixOfAKind

        XCTAssertEqual(combination.diceCount, 6)
    }

    func test_sixOnes_uses6Dice() {
        let combination = ScoringCombination.sixOnes

        XCTAssertEqual(combination.diceCount, 6)
    }

    // MARK: - Three of a Kind Tests

    func test_threeOnes_isWorth1000Points() {
        let combination = ScoringCombination.threeOfAKind(dieValue: 1)

        XCTAssertEqual(combination.points, 1000)
    }

    func test_threeSixes_isWorth600Points() {
        let combination = ScoringCombination.threeOfAKind(dieValue: 6)

        XCTAssertEqual(combination.points, 600)
    }

    // MARK: - Four of a Kind Tests

    func test_fourOfAKind_isWorth2000Points() {
        let combination = ScoringCombination.fourOfAKind

        XCTAssertEqual(combination.points, 2000)
    }

    // MARK: - Five of a Kind Tests

    func test_fiveOfAKind_isWorth3000Points() {
        let combination = ScoringCombination.fiveOfAKind

        XCTAssertEqual(combination.points, 3000)
    }

    // MARK: - Six of a Kind Tests

    func test_sixOfAKind_isWorth10000Points() {
        let combination = ScoringCombination.sixOfAKind

        XCTAssertEqual(combination.points, 10000)
    }

    func test_sixOnes_isInstantWin() {
        let combination = ScoringCombination.sixOnes

        XCTAssertTrue(combination.isInstantWin)
    }

    func test_sixOfAKind_isNotInstantWin() {
        let combination = ScoringCombination.sixOfAKind

        XCTAssertFalse(combination.isInstantWin)
    }

    // MARK: - Full House Tests

    func test_fullHouse_withThreeTwosAndPairOfFours_isWorth450Points() {
        let combination = ScoringCombination.fullHouse(tripletValue: 2)

        XCTAssertEqual(combination.points, 450)
    }

    func test_fullHouse_withThreeOnes_isWorth1250Points() {
        let combination = ScoringCombination.fullHouse(tripletValue: 1)

        XCTAssertEqual(combination.points, 1250)
    }

    func test_fullHouse_uses5Dice() {
        let combination = ScoringCombination.fullHouse(tripletValue: 3)

        XCTAssertEqual(combination.diceCount, 5)
    }

    // MARK: - Full Mansion Tests

    func test_fullMansion_isWorth2250Points() {
        let combination = ScoringCombination.fullMansion

        XCTAssertEqual(combination.points, 2250)
    }

    func test_fullMansion_uses6Dice() {
        let combination = ScoringCombination.fullMansion

        XCTAssertEqual(combination.diceCount, 6)
    }

    // MARK: - Three Pairs Tests

    func test_threePairs_isWorth1500Points() {
        let combination = ScoringCombination.threePairs

        XCTAssertEqual(combination.points, 1500)
    }

    func test_threePairs_uses6Dice() {
        let combination = ScoringCombination.threePairs

        XCTAssertEqual(combination.diceCount, 6)
    }

    // MARK: - Two Triplets Tests

    func test_twoTriplets_isWorth2500Points() {
        let combination = ScoringCombination.twoTriplets

        XCTAssertEqual(combination.points, 2500)
    }

    func test_twoTriplets_uses6Dice() {
        let combination = ScoringCombination.twoTriplets

        XCTAssertEqual(combination.diceCount, 6)
    }

    // MARK: - Small Straight Tests

    func test_smallStraight_isWorth1500Points() {
        let combination = ScoringCombination.smallStraight

        XCTAssertEqual(combination.points, 1500)
    }

    func test_smallStraight_uses5Dice() {
        let combination = ScoringCombination.smallStraight

        XCTAssertEqual(combination.diceCount, 5)
    }

    // MARK: - Large Straight Tests

    func test_largeStraight_isWorth1500Points() {
        let combination = ScoringCombination.largeStraight

        XCTAssertEqual(combination.points, 1500)
    }

    func test_largeStraight_uses6Dice() {
        let combination = ScoringCombination.largeStraight

        XCTAssertEqual(combination.diceCount, 6)
    }

    // MARK: - Six-Dice Farkle Tests

    func test_sixDiceFarkle_isWorth500Points() {
        let combination = ScoringCombination.sixDiceFarkle

        XCTAssertEqual(combination.points, 500)
    }

    func test_sixDiceFarkle_uses6Dice() {
        let combination = ScoringCombination.sixDiceFarkle

        XCTAssertEqual(combination.diceCount, 6)
    }

    func test_sixDiceFarkle_requiresFirstRoll() {
        let combination = ScoringCombination.sixDiceFarkle

        XCTAssertTrue(combination.requiresFirstRoll)
    }

    func test_singleOne_doesNotRequireFirstRoll() {
        let combination = ScoringCombination.singleOne

        XCTAssertFalse(combination.requiresFirstRoll)
    }

    func test_sixOfAKind_doesNotRequireFirstRoll() {
        let combination = ScoringCombination.sixOfAKind

        XCTAssertFalse(combination.requiresFirstRoll)
    }

    // MARK: - Display Name Tests

    func test_singleOne_displayNameIsSingle1() {
        let combination = ScoringCombination.singleOne

        XCTAssertEqual(combination.displayName, "Single 1")
    }

    func test_singleFive_displayNameIsSingle5() {
        let combination = ScoringCombination.singleFive

        XCTAssertEqual(combination.displayName, "Single 5")
    }

    func test_threeOfAKindWithOnes_displayNameIs3Ones() {
        let combination = ScoringCombination.threeOfAKind(dieValue: 1)

        XCTAssertEqual(combination.displayName, "Three 1s")
    }

    func test_threeOfAKindWithTwos_displayNameIs3Twos() {
        let combination = ScoringCombination.threeOfAKind(dieValue: 2)

        XCTAssertEqual(combination.displayName, "Three 2s")
    }

    func test_fourOfAKind_displayNameIs4OfAKind() {
        let combination = ScoringCombination.fourOfAKind

        XCTAssertEqual(combination.displayName, "Four of a Kind")
    }

    func test_fiveOfAKind_displayNameIs5OfAKind() {
        let combination = ScoringCombination.fiveOfAKind

        XCTAssertEqual(combination.displayName, "Five of a Kind")
    }

    func test_sixOfAKind_displayNameIs6OfAKind() {
        let combination = ScoringCombination.sixOfAKind

        XCTAssertEqual(combination.displayName, "Six of a Kind")
    }

    func test_sixOnes_displayNameIsSixOnes() {
        let combination = ScoringCombination.sixOnes

        XCTAssertEqual(combination.displayName, "Six 1s!")
    }

    func test_fullHouseWithThrees_displayNameIsFullHouse() {
        let combination = ScoringCombination.fullHouse(tripletValue: 3)

        XCTAssertEqual(combination.displayName, "Full House (3s)")
    }

    func test_fullMansion_displayNameIsFullMansion() {
        let combination = ScoringCombination.fullMansion

        XCTAssertEqual(combination.displayName, "Full Mansion")
    }

    func test_threePairs_displayNameIsThreePairs() {
        let combination = ScoringCombination.threePairs

        XCTAssertEqual(combination.displayName, "Three Pairs")
    }

    func test_twoTriplets_displayNameIsTwoTriplets() {
        let combination = ScoringCombination.twoTriplets

        XCTAssertEqual(combination.displayName, "Two Triplets")
    }

    func test_smallStraight_displayNameIsSmallStraight() {
        let combination = ScoringCombination.smallStraight

        XCTAssertEqual(combination.displayName, "Small Straight")
    }

    func test_largeStraight_displayNameIsLargeStraight() {
        let combination = ScoringCombination.largeStraight

        XCTAssertEqual(combination.displayName, "Large Straight")
    }

    func test_sixDiceFarkle_displayNameIs6DiceFarkle() {
        let combination = ScoringCombination.sixDiceFarkle

        XCTAssertEqual(combination.displayName, "Six-Dice Farkle")
    }

    // MARK: - points(using:) with Standard Config Tests

    func test_singleOne_withStandardConfig_returns100Points() {
        let combination = ScoringCombination.singleOne
        let config = ScoringConfig.standard

        XCTAssertEqual(combination.points(using: config), 100)
    }

    func test_singleFive_withStandardConfig_returns50Points() {
        let combination = ScoringCombination.singleFive
        let config = ScoringConfig.standard

        XCTAssertEqual(combination.points(using: config), 50)
    }

    func test_threeOfAKindWithOnes_withStandardConfig_returns1000Points() {
        let combination = ScoringCombination.threeOfAKind(dieValue: 1)
        let config = ScoringConfig.standard

        XCTAssertEqual(combination.points(using: config), 1000)
    }

    func test_threeOfAKindWithFours_withStandardConfig_returns400Points() {
        let combination = ScoringCombination.threeOfAKind(dieValue: 4)
        let config = ScoringConfig.standard

        XCTAssertEqual(combination.points(using: config), 400)
    }

    func test_fourOfAKind_withStandardConfig_returns2000Points() {
        let combination = ScoringCombination.fourOfAKind
        let config = ScoringConfig.standard

        XCTAssertEqual(combination.points(using: config), 2000)
    }

    // MARK: - points(using:) with Custom Points Tests

    func test_singleOne_withCustomPoints50_returns50Points() {
        let combination = ScoringCombination.singleOne
        var config = ScoringConfig.standard
        config.setCustomPoints(50, for: .singleOne)

        XCTAssertEqual(combination.points(using: config), 50)
    }

    func test_singleFive_withCustomPoints100_returns100Points() {
        let combination = ScoringCombination.singleFive
        var config = ScoringConfig.standard
        config.setCustomPoints(100, for: .singleFive)

        XCTAssertEqual(combination.points(using: config), 100)
    }

    func test_fourOfAKind_withCustomPoints1000_returns1000Points() {
        let combination = ScoringCombination.fourOfAKind
        var config = ScoringConfig.standard
        config.setCustomPoints(1000, for: .fourOfAKind)

        XCTAssertEqual(combination.points(using: config), 1000)
    }

    // MARK: - points(using:) with Custom Three of a Kind Multiplier Tests

    func test_threeOfAKindWithFours_with50xMultiplier_returns200Points() {
        let combination = ScoringCombination.threeOfAKind(dieValue: 4)
        var config = ScoringConfig.standard
        config.threeOfAKindMultiplier = 50

        XCTAssertEqual(combination.points(using: config), 200)
    }

    func test_threeOfAKindWithOnes_with50xMultiplier_stillReturns1000Points() {
        let combination = ScoringCombination.threeOfAKind(dieValue: 1)
        var config = ScoringConfig.standard
        config.threeOfAKindMultiplier = 50

        XCTAssertEqual(combination.points(using: config), 1000)
    }

    func test_threeOfAKindWithSixes_with200xMultiplier_returns1200Points() {
        let combination = ScoringCombination.threeOfAKind(dieValue: 6)
        var config = ScoringConfig.standard
        config.threeOfAKindMultiplier = 200

        XCTAssertEqual(combination.points(using: config), 1200)
    }
}
