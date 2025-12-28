import XCTest

/// Step definitions for Farkle game UI tests.
/// Maps Gherkin-style descriptions to XCUITest actions.
extension BDDTestCase {

    // MARK: - Given Steps (Setup)

    /// Launches the app with a new game
    /// Currently uses hardcoded players: "Player 1" and "Player 2"
    func launchGame() {
        app.launch()

        // Wait for the game view to appear
        let currentPlayer = app.staticTexts["currentPlayer"]
        XCTAssertTrue(currentPlayer.waitForExistence(timeout: 5), "Game view should appear")
    }

    // MARK: - When Steps (Actions)

    /// Taps a scoring combination button by its identifier
    func tapCombination(_ identifier: String) {
        let button = app.buttons[identifier]
        XCTAssertTrue(button.waitForExistence(timeout: 2), "Button '\(identifier)' should exist")
        XCTAssertTrue(button.isEnabled, "Button '\(identifier)' should be enabled")
        button.tap()
    }

    /// Taps the single one (100 points) button
    func recordSingleOne() {
        tapCombination("Single 1")
    }

    /// Taps the single five (50 points) button
    func recordSingleFive() {
        tapCombination("Single 5")
    }

    /// Taps a three of a kind button for specified die value
    func recordThreeOfAKind(dieValue: Int) {
        tapCombination("3x\(dieValue)")
    }

    /// Taps the four of a kind button
    func recordFourOfAKind() {
        tapCombination("4 of a Kind")
    }

    /// Taps the five of a kind button
    func recordFiveOfAKind() {
        tapCombination("5 of a Kind")
    }

    /// Taps the six of a kind button
    func recordSixOfAKind() {
        tapCombination("6 of a Kind")
    }

    /// Taps the small straight button
    func recordSmallStraight() {
        tapCombination("Small Straight")
    }

    /// Taps the large straight button
    func recordLargeStraight() {
        tapCombination("Large Straight")
    }

    /// Taps the three pairs button
    func recordThreePairs() {
        tapCombination("Three Pairs")
    }

    /// Taps the two triplets button
    func recordTwoTriplets() {
        tapCombination("Two Triplets")
    }

    /// Taps the full mansion button
    func recordFullMansion() {
        tapCombination("Full Mansion")
    }

    /// Taps the six dice farkle button
    func recordSixDiceFarkle() {
        tapCombination("Six-Dice Farkle")
    }

    /// Taps the six ones (instant win) button
    func recordSixOnes() {
        tapCombination("6 Ones")
    }

    /// Taps the bank button
    func bank() {
        let button = app.buttons["bankButton"]
        XCTAssertTrue(button.waitForExistence(timeout: 2), "Bank button should exist")
        button.tap()
    }

    /// Taps the farkle button
    func farkle() {
        let button = app.buttons["farkleButton"]
        XCTAssertTrue(button.waitForExistence(timeout: 2), "Farkle button should exist")
        button.tap()
    }

    // MARK: - Then Steps (Assertions)

    /// Formats a number the same way the app does (with locale-appropriate grouping)
    private func formattedNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    /// Asserts the turn score displays expected value
    func assertTurnScore(_ expected: Int) {
        let turnScore = app.staticTexts["turnScore"]
        XCTAssertTrue(turnScore.waitForExistence(timeout: 2), "Turn score should exist")
        XCTAssertEqual(turnScore.label, formattedNumber(expected), "Turn score should be \(expected)")
    }

    /// Asserts the dice remaining displays expected value
    func assertDiceRemaining(_ expected: Int) {
        let diceRemaining = app.staticTexts["diceRemaining"]
        XCTAssertTrue(diceRemaining.waitForExistence(timeout: 2), "Dice remaining should exist")
        XCTAssertEqual(diceRemaining.label, "\(expected)", "Dice remaining should be \(expected)")
    }

    /// Asserts the total score displays expected value
    func assertTotalScore(_ expected: Int) {
        let totalScore = app.staticTexts["totalScore"]
        XCTAssertTrue(totalScore.waitForExistence(timeout: 2), "Total score should exist")
        XCTAssertEqual(totalScore.label, formattedNumber(expected), "Total score should be \(expected)")
    }

    /// Asserts the current player is displayed
    func assertCurrentPlayer(_ name: String) {
        let currentPlayer = app.staticTexts["currentPlayer"]
        XCTAssertTrue(currentPlayer.waitForExistence(timeout: 2), "Current player should exist")
        XCTAssertEqual(currentPlayer.label, name, "Current player should be \(name)")
    }

    /// Asserts the bank button is enabled
    func assertCanBank() {
        let button = app.buttons["bankButton"]
        XCTAssertTrue(button.waitForExistence(timeout: 2), "Bank button should exist")
        XCTAssertTrue(button.isEnabled, "Bank button should be enabled")
    }

    /// Asserts the bank button is disabled
    func assertCannotBank() {
        let button = app.buttons["bankButton"]
        XCTAssertTrue(button.waitForExistence(timeout: 2), "Bank button should exist")
        XCTAssertFalse(button.isEnabled, "Bank button should be disabled")
    }

    /// Asserts a combination button is enabled
    func assertCombinationAvailable(_ identifier: String) {
        let button = app.buttons[identifier]
        XCTAssertTrue(button.waitForExistence(timeout: 2), "Button '\(identifier)' should exist")
        XCTAssertTrue(button.isEnabled, "Button '\(identifier)' should be enabled")
    }

    /// Asserts a combination button is disabled
    func assertCombinationUnavailable(_ identifier: String) {
        let button = app.buttons[identifier]
        XCTAssertTrue(button.waitForExistence(timeout: 2), "Button '\(identifier)' should exist")
        XCTAssertFalse(button.isEnabled, "Button '\(identifier)' should be disabled")
    }

    /// Asserts the game over overlay is shown with winner
    func assertGameOver(winner: String) {
        let gameOver = app.staticTexts["Game Over!"]
        XCTAssertTrue(gameOver.waitForExistence(timeout: 2), "Game over text should appear")

        let winnerText = app.staticTexts["\(winner) Wins!"]
        XCTAssertTrue(winnerText.exists, "\(winner) should be declared winner")
    }
}
