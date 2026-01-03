import XCTest

@testable import FarkleScorekeeper

final class ScoringCombinationTypeTests: XCTestCase {

    func test_allCases_containsAllScoringCombinationTypes() {
        let allCases = ScoringCombinationType.allCases

        XCTAssertTrue(allCases.contains(.singleOne))
        XCTAssertTrue(allCases.contains(.singleFive))
        XCTAssertTrue(allCases.contains(.threeOfAKind))
        XCTAssertTrue(allCases.contains(.fourOfAKind))
        XCTAssertTrue(allCases.contains(.fiveOfAKind))
        XCTAssertTrue(allCases.contains(.sixOfAKind))
        XCTAssertTrue(allCases.contains(.sixOnes))
        XCTAssertTrue(allCases.contains(.fullHouse))
        XCTAssertTrue(allCases.contains(.fullMansion))
        XCTAssertTrue(allCases.contains(.threePairs))
        XCTAssertTrue(allCases.contains(.twoTriplets))
        XCTAssertTrue(allCases.contains(.smallStraight))
        XCTAssertTrue(allCases.contains(.largeStraight))
        XCTAssertTrue(allCases.contains(.sixDiceFarkle))
    }

    // MARK: - ScoringCombination.combinationType Tests

    func test_singleOne_combinationType_isSingleOne() {
        let combination = ScoringCombination.singleOne

        XCTAssertEqual(combination.combinationType, .singleOne)
    }

    func test_singleFive_combinationType_isSingleFive() {
        let combination = ScoringCombination.singleFive

        XCTAssertEqual(combination.combinationType, .singleFive)
    }

    func test_threeOfAKind_combinationType_isThreeOfAKind() {
        let combination = ScoringCombination.threeOfAKind(dieValue: 3)

        XCTAssertEqual(combination.combinationType, .threeOfAKind)
    }

    func test_fourOfAKind_combinationType_isFourOfAKind() {
        let combination = ScoringCombination.fourOfAKind

        XCTAssertEqual(combination.combinationType, .fourOfAKind)
    }

    func test_fiveOfAKind_combinationType_isFiveOfAKind() {
        let combination = ScoringCombination.fiveOfAKind

        XCTAssertEqual(combination.combinationType, .fiveOfAKind)
    }

    func test_sixOfAKind_combinationType_isSixOfAKind() {
        let combination = ScoringCombination.sixOfAKind

        XCTAssertEqual(combination.combinationType, .sixOfAKind)
    }

    func test_sixOnes_combinationType_isSixOnes() {
        let combination = ScoringCombination.sixOnes

        XCTAssertEqual(combination.combinationType, .sixOnes)
    }

    func test_fullHouse_combinationType_isFullHouse() {
        let combination = ScoringCombination.fullHouse(tripletValue: 2)

        XCTAssertEqual(combination.combinationType, .fullHouse)
    }

    func test_fullMansion_combinationType_isFullMansion() {
        let combination = ScoringCombination.fullMansion

        XCTAssertEqual(combination.combinationType, .fullMansion)
    }

    func test_threePairs_combinationType_isThreePairs() {
        let combination = ScoringCombination.threePairs

        XCTAssertEqual(combination.combinationType, .threePairs)
    }

    func test_twoTriplets_combinationType_isTwoTriplets() {
        let combination = ScoringCombination.twoTriplets

        XCTAssertEqual(combination.combinationType, .twoTriplets)
    }

    func test_smallStraight_combinationType_isSmallStraight() {
        let combination = ScoringCombination.smallStraight

        XCTAssertEqual(combination.combinationType, .smallStraight)
    }

    func test_largeStraight_combinationType_isLargeStraight() {
        let combination = ScoringCombination.largeStraight

        XCTAssertEqual(combination.combinationType, .largeStraight)
    }

    func test_sixDiceFarkle_combinationType_isSixDiceFarkle() {
        let combination = ScoringCombination.sixDiceFarkle

        XCTAssertEqual(combination.combinationType, .sixDiceFarkle)
    }

    // MARK: - displayName Tests

    func test_singleOne_displayName() {
        XCTAssertEqual(ScoringCombinationType.singleOne.displayName, "Single 1")
    }

    func test_singleFive_displayName() {
        XCTAssertEqual(ScoringCombinationType.singleFive.displayName, "Single 5")
    }

    func test_threeOfAKind_displayName() {
        XCTAssertEqual(ScoringCombinationType.threeOfAKind.displayName, "Three of a Kind")
    }

    func test_threePairs_displayName() {
        XCTAssertEqual(ScoringCombinationType.threePairs.displayName, "Three Pairs")
    }

    func test_sixDiceFarkle_displayName() {
        XCTAssertEqual(ScoringCombinationType.sixDiceFarkle.displayName, "Six-Dice Farkle")
    }

    // MARK: - defaultPoints Tests

    func test_singleOne_defaultPoints() {
        XCTAssertEqual(ScoringCombinationType.singleOne.defaultPoints, 100)
    }

    func test_singleFive_defaultPoints() {
        XCTAssertEqual(ScoringCombinationType.singleFive.defaultPoints, 50)
    }

    func test_fourOfAKind_defaultPoints() {
        XCTAssertEqual(ScoringCombinationType.fourOfAKind.defaultPoints, 2000)
    }

    func test_fiveOfAKind_defaultPoints() {
        XCTAssertEqual(ScoringCombinationType.fiveOfAKind.defaultPoints, 3000)
    }

    func test_sixDiceFarkle_defaultPoints() {
        XCTAssertEqual(ScoringCombinationType.sixDiceFarkle.defaultPoints, 500)
    }

    // MARK: - supportsCustomPoints Tests

    func test_singleOne_supportsCustomPoints() {
        XCTAssertTrue(ScoringCombinationType.singleOne.supportsCustomPoints)
    }

    func test_threeOfAKind_doesNotSupportCustomPoints() {
        XCTAssertFalse(ScoringCombinationType.threeOfAKind.supportsCustomPoints)
    }

    func test_sixOnes_doesNotSupportCustomPoints() {
        XCTAssertFalse(ScoringCombinationType.sixOnes.supportsCustomPoints)
    }

    func test_fullHouse_doesNotSupportCustomPoints() {
        XCTAssertFalse(ScoringCombinationType.fullHouse.supportsCustomPoints)
    }
}
