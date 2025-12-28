import SwiftData
import XCTest

@testable import FarkleScorekeeper

@MainActor
final class StatisticsRepositoryTests: XCTestCase {

    private var modelContainer: ModelContainer!
    private var modelContext: ModelContext!
    private var repository: StatisticsRepository!

    override func setUp() async throws {
        let schema = Schema([PlayerStatisticsRecord.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(for: schema, configurations: [configuration])
        modelContext = modelContainer.mainContext
        repository = StatisticsRepository(modelContext: modelContext)
    }

    override func tearDown() async throws {
        modelContainer = nil
        modelContext = nil
        repository = nil
    }

    // MARK: - Fetch Tests

    func test_fetchStatistics_whenNoStatisticsExist_returnsNil() async throws {
        let result = try repository.fetchStatistics(for: "Alice")

        XCTAssertNil(result)
    }

    func test_fetchStatistics_whenStatisticsExist_returnsStatistics() async throws {
        let record = PlayerStatisticsRecord(playerName: "Alice")
        modelContext.insert(record)
        try modelContext.save()

        let result = try repository.fetchStatistics(for: "Alice")

        XCTAssertNotNil(result)
        XCTAssertEqual(result?.playerName, "Alice")
    }

    func test_fetchStatistics_returnsCorrectPlayerStats() async throws {
        let aliceRecord = PlayerStatisticsRecord(playerName: "Alice")
        aliceRecord.gamesPlayed = 10
        let bobRecord = PlayerStatisticsRecord(playerName: "Bob")
        bobRecord.gamesPlayed = 5
        modelContext.insert(aliceRecord)
        modelContext.insert(bobRecord)
        try modelContext.save()

        let result = try repository.fetchStatistics(for: "Alice")

        XCTAssertEqual(result?.gamesPlayed, 10)
    }

    // MARK: - Fetch or Create Tests

    func test_fetchOrCreateStatistics_whenNoStatisticsExist_createsNewStatistics() async throws {
        let result = try repository.fetchOrCreateStatistics(for: "Alice")

        XCTAssertEqual(result.playerName, "Alice")
        XCTAssertEqual(result.gamesPlayed, 0)
    }

    func test_fetchOrCreateStatistics_whenStatisticsExist_returnsExistingStatistics() async throws {
        let record = PlayerStatisticsRecord(playerName: "Alice")
        record.gamesPlayed = 10
        modelContext.insert(record)
        try modelContext.save()

        let result = try repository.fetchOrCreateStatistics(for: "Alice")

        XCTAssertEqual(result.gamesPlayed, 10)
    }

    func test_fetchOrCreateStatistics_insertsNewStatisticsIntoContext() async throws {
        _ = try repository.fetchOrCreateStatistics(for: "Alice")
        try modelContext.save()

        let fetchDescriptor = FetchDescriptor<PlayerStatisticsRecord>(
            predicate: #Predicate { $0.playerName == "Alice" }
        )
        let results = try modelContext.fetch(fetchDescriptor)

        XCTAssertEqual(results.count, 1)
    }

    // MARK: - Record Game Result Tests

    func test_recordGameResult_whenNoStatisticsExist_createsAndUpdatesStatistics() async throws {
        try repository.recordGameResult(for: "Alice", score: 10000, didWin: true)

        let stats = try repository.fetchStatistics(for: "Alice")
        XCTAssertEqual(stats?.gamesPlayed, 1)
        XCTAssertEqual(stats?.gamesWon, 1)
        XCTAssertEqual(stats?.totalPoints, 10000)
    }

    func test_recordGameResult_whenStatisticsExist_updatesExistingStatistics() async throws {
        let record = PlayerStatisticsRecord(playerName: "Alice")
        record.gamesPlayed = 5
        record.gamesWon = 3
        record.totalPoints = 50000
        modelContext.insert(record)
        try modelContext.save()

        try repository.recordGameResult(for: "Alice", score: 12000, didWin: true)

        let updatedStats = try repository.fetchStatistics(for: "Alice")
        XCTAssertEqual(updatedStats?.gamesPlayed, 6)
        XCTAssertEqual(updatedStats?.gamesWon, 4)
        XCTAssertEqual(updatedStats?.totalPoints, 62000)
    }

    func test_recordGameResult_updatesHighestScore_whenNewHighScore() async throws {
        let record = PlayerStatisticsRecord(playerName: "Alice")
        record.highestGameScore = 10000
        modelContext.insert(record)
        try modelContext.save()

        try repository.recordGameResult(for: "Alice", score: 15000, didWin: true)

        let updatedStats = try repository.fetchStatistics(for: "Alice")
        XCTAssertEqual(updatedStats?.highestGameScore, 15000)
    }

    func test_recordGameResult_keepsHighestScore_whenScoreIsLower() async throws {
        let record = PlayerStatisticsRecord(playerName: "Alice")
        record.highestGameScore = 15000
        modelContext.insert(record)
        try modelContext.save()

        try repository.recordGameResult(for: "Alice", score: 10000, didWin: false)

        let updatedStats = try repository.fetchStatistics(for: "Alice")
        XCTAssertEqual(updatedStats?.highestGameScore, 15000)
    }

    // MARK: - Fetch All Statistics Tests

    func test_fetchAllStatistics_whenNoStatisticsExist_returnsEmptyArray() async throws {
        let results = try repository.fetchAllStatistics()

        XCTAssertTrue(results.isEmpty)
    }

    func test_fetchAllStatistics_returnsAllPlayerStatistics() async throws {
        modelContext.insert(PlayerStatisticsRecord(playerName: "Alice"))
        modelContext.insert(PlayerStatisticsRecord(playerName: "Bob"))
        modelContext.insert(PlayerStatisticsRecord(playerName: "Charlie"))
        try modelContext.save()

        let results = try repository.fetchAllStatistics()

        XCTAssertEqual(results.count, 3)
    }

    // MARK: - Persistence Tests

    func test_statisticsPersistBetweenSessions() async throws {
        try repository.recordGameResult(for: "Alice", score: 10000, didWin: true)
        try modelContext.save()

        let newRepository = StatisticsRepository(modelContext: modelContext)
        let stats = try newRepository.fetchStatistics(for: "Alice")

        XCTAssertNotNil(stats)
        XCTAssertEqual(stats?.gamesWon, 1)
    }

    // MARK: - Per-Player Tracking Tests

    func test_eachPlayerHasSeparateStatistics() async throws {
        try repository.recordGameResult(for: "Alice", score: 10000, didWin: true)
        try repository.recordGameResult(for: "Bob", score: 8000, didWin: false)

        let aliceStats = try repository.fetchStatistics(for: "Alice")
        let bobStats = try repository.fetchStatistics(for: "Bob")

        XCTAssertEqual(aliceStats?.gamesWon, 1)
        XCTAssertEqual(bobStats?.gamesWon, 0)
        XCTAssertNotEqual(aliceStats?.playerName, bobStats?.playerName)
    }
}
