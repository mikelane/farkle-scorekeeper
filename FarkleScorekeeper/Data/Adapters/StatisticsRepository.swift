import Foundation
import SwiftData

@MainActor
final class StatisticsRepository: StatisticsRepositoryProtocol, Sendable {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchStatistics(for playerName: String) throws -> PlayerStatistics? {
        let fetchDescriptor = FetchDescriptor<PlayerStatisticsRecord>(
            predicate: #Predicate { $0.playerName == playerName }
        )
        let results = try modelContext.fetch(fetchDescriptor)
        return results.first?.toDomain()
    }

    func fetchOrCreateStatistics(for playerName: String) throws -> PlayerStatistics {
        if let existing = try fetchStatistics(for: playerName) {
            return existing
        }
        let record = PlayerStatisticsRecord(playerName: playerName)
        modelContext.insert(record)
        return record.toDomain()
    }

    func recordGameResult(for playerName: String, score: Int, didWin: Bool) throws {
        let fetchDescriptor = FetchDescriptor<PlayerStatisticsRecord>(
            predicate: #Predicate { $0.playerName == playerName }
        )
        let results = try modelContext.fetch(fetchDescriptor)

        let record: PlayerStatisticsRecord
        if let existing = results.first {
            record = existing
        } else {
            record = PlayerStatisticsRecord(playerName: playerName)
            modelContext.insert(record)
        }

        var stats = record.toDomain()
        stats.recordGameResult(score: score, didWin: didWin)
        record.update(from: stats)
        try modelContext.save()
    }

    func fetchAllStatistics() throws -> [PlayerStatistics] {
        let fetchDescriptor = FetchDescriptor<PlayerStatisticsRecord>()
        return try modelContext.fetch(fetchDescriptor).map { $0.toDomain() }
    }

    func save(_ statistics: PlayerStatistics) throws {
        let playerNameToFind = statistics.playerName
        let fetchDescriptor = FetchDescriptor<PlayerStatisticsRecord>(
            predicate: #Predicate { $0.playerName == playerNameToFind }
        )
        let results = try modelContext.fetch(fetchDescriptor)

        if let existing = results.first {
            existing.update(from: statistics)
        } else {
            let record = PlayerStatisticsRecord.from(statistics)
            modelContext.insert(record)
        }
        try modelContext.save()
    }
}
