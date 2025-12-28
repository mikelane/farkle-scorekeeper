import Foundation

@MainActor
protocol StatisticsRepositoryProtocol: Sendable {
    func fetchStatistics(for playerName: String) throws -> PlayerStatistics?
    func fetchOrCreateStatistics(for playerName: String) throws -> PlayerStatistics
    func recordGameResult(for playerName: String, score: Int, didWin: Bool) throws
    func fetchAllStatistics() throws -> [PlayerStatistics]
    func save(_ statistics: PlayerStatistics) throws
}
