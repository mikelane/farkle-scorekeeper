import XCTest

@testable import FarkleScorekeeper

final class PlayerStatisticsTests: XCTestCase {

    // MARK: - Initialization Tests

    func test_init_createsStatisticsWithProvidedPlayerName() {
        let stats = PlayerStatistics(playerName: "Alice")

        XCTAssertEqual(stats.playerName, "Alice")
    }

    func test_init_defaultGamesPlayedIsZero() {
        let stats = PlayerStatistics(playerName: "Alice")

        XCTAssertEqual(stats.gamesPlayed, 0)
    }

    func test_init_defaultGamesWonIsZero() {
        let stats = PlayerStatistics(playerName: "Alice")

        XCTAssertEqual(stats.gamesWon, 0)
    }

    func test_init_defaultTotalPointsIsZero() {
        let stats = PlayerStatistics(playerName: "Alice")

        XCTAssertEqual(stats.totalPoints, 0)
    }

    func test_init_defaultHighestGameScoreIsZero() {
        let stats = PlayerStatistics(playerName: "Alice")

        XCTAssertEqual(stats.highestGameScore, 0)
    }

    // MARK: - Games Played Tracking

    func test_gamesPlayed_tracksNumberOfGamesPlayed() {
        var stats = PlayerStatistics(playerName: "Alice")
        stats.gamesPlayed = 10

        XCTAssertEqual(stats.gamesPlayed, 10)
    }

    // MARK: - Games Won Tracking

    func test_gamesWon_tracksNumberOfGamesWon() {
        var stats = PlayerStatistics(playerName: "Alice")
        stats.gamesWon = 6

        XCTAssertEqual(stats.gamesWon, 6)
    }

    // MARK: - Win Rate Calculation

    func test_winRate_whenNoGamesPlayed_returnsZero() {
        let stats = PlayerStatistics(playerName: "Alice")

        XCTAssertEqual(stats.winRate, 0.0)
    }

    func test_winRate_calculatesPercentageOfGamesWon() {
        var stats = PlayerStatistics(playerName: "Alice")
        stats.gamesPlayed = 10
        stats.gamesWon = 6

        XCTAssertEqual(stats.winRate, 0.6, accuracy: 0.001)
    }

    func test_winRate_whenAllGamesWon_returnsOne() {
        var stats = PlayerStatistics(playerName: "Alice")
        stats.gamesPlayed = 5
        stats.gamesWon = 5

        XCTAssertEqual(stats.winRate, 1.0)
    }

    func test_winRate_whenNoGamesWon_returnsZero() {
        var stats = PlayerStatistics(playerName: "Alice")
        stats.gamesPlayed = 10
        stats.gamesWon = 0

        XCTAssertEqual(stats.winRate, 0.0)
    }

    // MARK: - Highest Game Score Tracking

    func test_highestGameScore_tracksHighestScoreAchieved() {
        var stats = PlayerStatistics(playerName: "Alice")
        stats.highestGameScore = 15000

        XCTAssertEqual(stats.highestGameScore, 15000)
    }

    // MARK: - Total Points Tracking

    func test_totalPoints_tracksAllTimePoints() {
        var stats = PlayerStatistics(playerName: "Alice")
        stats.totalPoints = 150000

        XCTAssertEqual(stats.totalPoints, 150000)
    }

    // MARK: - Average Score Calculation

    func test_averageScore_whenNoGamesPlayed_returnsZero() {
        let stats = PlayerStatistics(playerName: "Alice")

        XCTAssertEqual(stats.averageScore, 0)
    }

    func test_averageScore_calculatesAveragePointsPerGame() {
        var stats = PlayerStatistics(playerName: "Alice")
        stats.gamesPlayed = 3
        stats.totalPoints = 30500

        XCTAssertEqual(stats.averageScore, 10166)
    }

    func test_averageScore_truncatesToInteger_whenDivisionHasRemainder() {
        var stats = PlayerStatistics(playerName: "Alice")
        stats.gamesPlayed = 3
        stats.totalPoints = 30501

        XCTAssertEqual(stats.averageScore, 10167)
    }

    // MARK: - Record Game Result

    func test_recordGameResult_incrementsGamesPlayed() {
        var stats = PlayerStatistics(playerName: "Alice")

        stats.recordGameResult(score: 10000, didWin: false)

        XCTAssertEqual(stats.gamesPlayed, 1)
    }

    func test_recordGameResult_whenWon_incrementsGamesWon() {
        var stats = PlayerStatistics(playerName: "Alice")

        stats.recordGameResult(score: 10000, didWin: true)

        XCTAssertEqual(stats.gamesWon, 1)
    }

    func test_recordGameResult_whenLost_doesNotIncrementGamesWon() {
        var stats = PlayerStatistics(playerName: "Alice")

        stats.recordGameResult(score: 8000, didWin: false)

        XCTAssertEqual(stats.gamesWon, 0)
    }

    func test_recordGameResult_addScoreToTotalPoints() {
        var stats = PlayerStatistics(playerName: "Alice")

        stats.recordGameResult(score: 10500, didWin: true)

        XCTAssertEqual(stats.totalPoints, 10500)
    }

    func test_recordGameResult_accumulatesTotalPointsAcrossGames() {
        var stats = PlayerStatistics(playerName: "Alice")

        stats.recordGameResult(score: 10500, didWin: true)
        stats.recordGameResult(score: 8000, didWin: false)
        stats.recordGameResult(score: 12000, didWin: true)

        XCTAssertEqual(stats.totalPoints, 30500)
    }

    func test_recordGameResult_updatesHighestScore_whenNewHighScore() {
        var stats = PlayerStatistics(playerName: "Alice")

        stats.recordGameResult(score: 15000, didWin: true)

        XCTAssertEqual(stats.highestGameScore, 15000)
    }

    func test_recordGameResult_keepsHighestScore_whenScoreIsLower() {
        var stats = PlayerStatistics(playerName: "Alice")
        stats.recordGameResult(score: 15000, didWin: true)

        stats.recordGameResult(score: 10000, didWin: false)

        XCTAssertEqual(stats.highestGameScore, 15000)
    }

    // MARK: - Per-Player Tracking

    func test_differentPlayersHaveSeparateStatistics() {
        var aliceStats = PlayerStatistics(playerName: "Alice")
        var bobStats = PlayerStatistics(playerName: "Bob")

        aliceStats.recordGameResult(score: 10000, didWin: true)
        bobStats.recordGameResult(score: 8000, didWin: false)

        XCTAssertEqual(aliceStats.gamesWon, 1)
        XCTAssertEqual(bobStats.gamesWon, 0)
        XCTAssertNotEqual(aliceStats.playerName, bobStats.playerName)
    }

    // MARK: - Identifiable Tests

    func test_conformsToIdentifiable() {
        let stats = PlayerStatistics(playerName: "Alice")

        XCTAssertNotNil(stats.id)
    }

    func test_twoInstancesHaveDifferentIds() {
        let stats1 = PlayerStatistics(playerName: "Alice")
        let stats2 = PlayerStatistics(playerName: "Alice")

        XCTAssertNotEqual(stats1.id, stats2.id)
    }
}
