import Foundation
import SwiftData

@Model
final class PlayerStatisticsRecord: Sendable {
    var id: UUID
    @Attribute(.unique) var playerName: String
    var gamesPlayed: Int
    var gamesWon: Int
    var totalPoints: Int
    var highestGameScore: Int

    init(playerName: String) {
        self.id = UUID()
        self.playerName = playerName
        self.gamesPlayed = 0
        self.gamesWon = 0
        self.totalPoints = 0
        self.highestGameScore = 0
    }

    init(
        id: UUID,
        playerName: String,
        gamesPlayed: Int,
        gamesWon: Int,
        totalPoints: Int,
        highestGameScore: Int
    ) {
        self.id = id
        self.playerName = playerName
        self.gamesPlayed = gamesPlayed
        self.gamesWon = gamesWon
        self.totalPoints = totalPoints
        self.highestGameScore = highestGameScore
    }

    func toDomain() -> PlayerStatistics {
        PlayerStatistics(
            id: id,
            playerName: playerName,
            gamesPlayed: gamesPlayed,
            gamesWon: gamesWon,
            totalPoints: totalPoints,
            highestGameScore: highestGameScore
        )
    }

    static func from(_ statistics: PlayerStatistics) -> PlayerStatisticsRecord {
        PlayerStatisticsRecord(
            id: statistics.id,
            playerName: statistics.playerName,
            gamesPlayed: statistics.gamesPlayed,
            gamesWon: statistics.gamesWon,
            totalPoints: statistics.totalPoints,
            highestGameScore: statistics.highestGameScore
        )
    }

    func update(from statistics: PlayerStatistics) {
        self.gamesPlayed = statistics.gamesPlayed
        self.gamesWon = statistics.gamesWon
        self.totalPoints = statistics.totalPoints
        self.highestGameScore = statistics.highestGameScore
    }
}
