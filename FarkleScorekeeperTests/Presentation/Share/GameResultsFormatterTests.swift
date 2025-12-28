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

    // MARK: - Ordinal Suffix Edge Cases

    func test_formatCurrentStandings_11thPlace_usesTh() {
        let players = (1...11).map { PlayerResult(name: "Player\($0)", score: 1000 - $0, rank: $0) }
        let formatter = GameResultsFormatter()

        let result = formatter.formatCurrentStandings(players: players)

        XCTAssertTrue(result.contains("11th: Player11"), "11th should use 'th' suffix, not 'st'")
    }

    func test_formatCurrentStandings_12thPlace_usesTh() {
        let players = (1...12).map { PlayerResult(name: "Player\($0)", score: 1000 - $0, rank: $0) }
        let formatter = GameResultsFormatter()

        let result = formatter.formatCurrentStandings(players: players)

        XCTAssertTrue(result.contains("12th: Player12"), "12th should use 'th' suffix, not 'nd'")
    }

    func test_formatCurrentStandings_13thPlace_usesTh() {
        let players = (1...13).map { PlayerResult(name: "Player\($0)", score: 1000 - $0, rank: $0) }
        let formatter = GameResultsFormatter()

        let result = formatter.formatCurrentStandings(players: players)

        XCTAssertTrue(result.contains("13th: Player13"), "13th should use 'th' suffix, not 'rd'")
    }

    func test_formatCurrentStandings_21stPlace_usesSt() {
        let players = (1...21).map { PlayerResult(name: "Player\($0)", score: 1000 - $0, rank: $0) }
        let formatter = GameResultsFormatter()

        let result = formatter.formatCurrentStandings(players: players)

        XCTAssertTrue(result.contains("21st: Player21"), "21st should use 'st' suffix")
    }

    func test_formatCurrentStandings_22ndPlace_usesNd() {
        let players = (1...22).map { PlayerResult(name: "Player\($0)", score: 1000 - $0, rank: $0) }
        let formatter = GameResultsFormatter()

        let result = formatter.formatCurrentStandings(players: players)

        XCTAssertTrue(result.contains("22nd: Player22"), "22nd should use 'nd' suffix")
    }

    func test_formatCurrentStandings_23rdPlace_usesRd() {
        let players = (1...23).map { PlayerResult(name: "Player\($0)", score: 1000 - $0, rank: $0) }
        let formatter = GameResultsFormatter()

        let result = formatter.formatCurrentStandings(players: players)

        XCTAssertTrue(result.contains("23rd: Player23"), "23rd should use 'rd' suffix")
    }

    func test_formatCurrentStandings_111thPlace_usesTh() {
        let players = (1...111).map { PlayerResult(name: "P\($0)", score: 1000 - $0, rank: $0) }
        let formatter = GameResultsFormatter()

        let result = formatter.formatCurrentStandings(players: players)

        XCTAssertTrue(result.contains("111th: P111"), "111th should use 'th' suffix (teens rule applies to x11)")
    }

    func test_formatCurrentStandings_112thPlace_usesTh() {
        let players = (1...112).map { PlayerResult(name: "P\($0)", score: 1000 - $0, rank: $0) }
        let formatter = GameResultsFormatter()

        let result = formatter.formatCurrentStandings(players: players)

        XCTAssertTrue(result.contains("112th: P112"), "112th should use 'th' suffix (teens rule applies to x12)")
    }

    func test_formatCurrentStandings_113thPlace_usesTh() {
        let players = (1...113).map { PlayerResult(name: "P\($0)", score: 1000 - $0, rank: $0) }
        let formatter = GameResultsFormatter()

        let result = formatter.formatCurrentStandings(players: players)

        XCTAssertTrue(result.contains("113th: P113"), "113th should use 'th' suffix (teens rule applies to x13)")
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
