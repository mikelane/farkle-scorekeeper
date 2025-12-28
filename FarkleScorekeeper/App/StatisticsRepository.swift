import Foundation
import SwiftData

@MainActor
final class StatisticsRepository: Sendable {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchStatistics(for playerName: String) throws -> PlayerStatistics? {
        let fetchDescriptor = FetchDescriptor<PlayerStatistics>(
            predicate: #Predicate { $0.playerName == playerName }
        )
        let results = try modelContext.fetch(fetchDescriptor)
        return results.first
    }

    func fetchOrCreateStatistics(for playerName: String) throws -> PlayerStatistics {
        if let existing = try fetchStatistics(for: playerName) {
            return existing
        }
        let stats = PlayerStatistics(playerName: playerName)
        modelContext.insert(stats)
        return stats
    }

    func recordGameResult(for playerName: String, score: Int, didWin: Bool) throws {
        let stats = try fetchOrCreateStatistics(for: playerName)
        stats.recordGameResult(score: score, didWin: didWin)
        try modelContext.save()
    }

    func fetchAllStatistics() throws -> [PlayerStatistics] {
        let fetchDescriptor = FetchDescriptor<PlayerStatistics>()
        return try modelContext.fetch(fetchDescriptor)
    }
}
