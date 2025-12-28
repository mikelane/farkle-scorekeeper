import XCTest

@testable import FarkleScorekeeper

final class GameResultsFormatterTests: XCTestCase {

    // MARK: - Single Player Results

    func test_format_singlePlayer_includesPlayerNameAndScore() {
        let players = [
            PlayerResult(name: "Alice", score: 10500, rank: 1)
        ]
        let formatter = GameResultsFormatter()

        let result = formatter.format(players: players)

        XCTAssertTrue(result.contains("Alice"))
        XCTAssertTrue(result.contains("10,500"))
    }

    func test_format_singlePlayer_includesWinnerEmoji() {
        let players = [
            PlayerResult(name: "Alice", score: 10500, rank: 1)
        ]
        let formatter = GameResultsFormatter()

        let result = formatter.format(players: players)

        XCTAssertTrue(result.contains("Winner"))
    }

    // MARK: - Multiple Player Results

    func test_format_threePlayers_ranksPlayersCorrectly() {
        let players = [
            PlayerResult(name: "Alice", score: 10500, rank: 1),
            PlayerResult(name: "Bob", score: 8200, rank: 2),
            PlayerResult(name: "Charlie", score: 7100, rank: 3)
        ]
        let formatter = GameResultsFormatter()

        let result = formatter.format(players: players)

        XCTAssertTrue(result.contains("Winner: Alice"))
        XCTAssertTrue(result.contains("2nd: Bob"))
        XCTAssertTrue(result.contains("3rd: Charlie"))
    }

    func test_format_fourPlayers_includes4thPlace() {
        let players = [
            PlayerResult(name: "Alice", score: 10500, rank: 1),
            PlayerResult(name: "Bob", score: 8200, rank: 2),
            PlayerResult(name: "Charlie", score: 7100, rank: 3),
            PlayerResult(name: "Dave", score: 5000, rank: 4)
        ]
        let formatter = GameResultsFormatter()

        let result = formatter.format(players: players)

        XCTAssertTrue(result.contains("4th: Dave"))
    }

    // MARK: - Header and Footer

    func test_format_includesGameTitle() {
        let players = [
            PlayerResult(name: "Alice", score: 10500, rank: 1)
        ]
        let formatter = GameResultsFormatter()

        let result = formatter.format(players: players)

        XCTAssertTrue(result.contains("Farkle Game Results"))
    }

    func test_format_includesAppAttribution() {
        let players = [
            PlayerResult(name: "Alice", score: 10500, rank: 1)
        ]
        let formatter = GameResultsFormatter()

        let result = formatter.format(players: players)

        XCTAssertTrue(result.contains("Played with Farkle Scorekeeper"))
    }

    // MARK: - Score Formatting

    func test_format_formatsScoresWithCommas() {
        let players = [
            PlayerResult(name: "Alice", score: 1000000, rank: 1)
        ]
        let formatter = GameResultsFormatter()

        let result = formatter.format(players: players)

        XCTAssertTrue(result.contains("1,000,000"))
    }

    func test_format_smallScores_noCommas() {
        let players = [
            PlayerResult(name: "Alice", score: 500, rank: 1)
        ]
        let formatter = GameResultsFormatter()

        let result = formatter.format(players: players)

        XCTAssertTrue(result.contains("500"))
    }

    // MARK: - In-Progress Game Formatting

    func test_formatCurrentStandings_includesCurrentStandingsHeader() {
        let players = [
            PlayerResult(name: "Alice", score: 5000, rank: 1),
            PlayerResult(name: "Bob", score: 3000, rank: 2)
        ]
        let formatter = GameResultsFormatter()

        let result = formatter.formatCurrentStandings(players: players)

        XCTAssertTrue(result.contains("Current Standings"))
    }

    func test_formatCurrentStandings_excludesWinnerLabel() {
        let players = [
            PlayerResult(name: "Alice", score: 5000, rank: 1)
        ]
        let formatter = GameResultsFormatter()

        let result = formatter.formatCurrentStandings(players: players)

        XCTAssertFalse(result.contains("Winner"))
    }

    func test_formatCurrentStandings_usesOrdinalPositions() {
        let players = [
            PlayerResult(name: "Alice", score: 5000, rank: 1),
            PlayerResult(name: "Bob", score: 3000, rank: 2)
        ]
        let formatter = GameResultsFormatter()

        let result = formatter.formatCurrentStandings(players: players)

        XCTAssertTrue(result.contains("1st: Alice"))
        XCTAssertTrue(result.contains("2nd: Bob"))
    }

    // MARK: - PlayerResult from Game

    func test_createResults_fromGame_ranksPlayersByScore() {
        var game = Game(playerNames: ["Alice", "Bob", "Charlie"])
        // Alice (player 0) scores 3000 points (fiveOfAKind uses 5 dice, 1 remaining, can bank)
        game.addScore(.fiveOfAKind)
        XCTAssertTrue(game.bankPoints())
        // Bob (player 1) scores 2000 points (fourOfAKind uses 4 dice, 2 remaining, can bank)
        game.addScore(.fourOfAKind)
        XCTAssertTrue(game.bankPoints())
        // Charlie (player 2) scores 100 points (singleOne uses 1 die, needs another to bank)
        game.addScore(.singleOne)
        game.addScore(.fourOfAKind) // Now has 1 die remaining, can bank
        XCTAssertTrue(game.bankPoints()) // Total: 100 + 2000 = 2100

        let results = GameResultsFormatter.createResults(from: game)

        // Ranked by score: Alice (3000) > Charlie (2100) > Bob (2000)
        XCTAssertEqual(results[0].name, "Alice")
        XCTAssertEqual(results[0].rank, 1)
        XCTAssertEqual(results[1].name, "Charlie")
        XCTAssertEqual(results[1].rank, 2)
        XCTAssertEqual(results[2].name, "Bob")
        XCTAssertEqual(results[2].rank, 3)
    }

    func test_createResults_tiedScores_assignsSameRank() {
        var game = Game(playerNames: ["Alice", "Bob"])
        game.addScore(.fourOfAKind)
        _ = game.bankPoints()
        game.addScore(.fourOfAKind)
        _ = game.bankPoints()

        let results = GameResultsFormatter.createResults(from: game)

        XCTAssertEqual(results[0].rank, 1)
        XCTAssertEqual(results[1].rank, 1)
    }
}
