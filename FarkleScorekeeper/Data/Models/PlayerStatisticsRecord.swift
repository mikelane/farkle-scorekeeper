import Foundation
@preconcurrency import SwiftData

@Model
final class PlayerStatisticsRecord {
    var id: UUID
    @Attribute(.unique) var playerName: String
    var gamesPlayed: Int
    var gamesWon: Int
    var totalPoints: Int
    var highestGameScore: Int
    var farkleCount: Int
    var hotDiceCount: Int
    var highestTurnScore: Int
    var instantWins: Int
    var sixOfAKindCount: Int
    var currentWinStreak: Int
    var bestWinStreak: Int

    init(playerName: String) {
        self.id = UUID()
        self.playerName = playerName
        self.gamesPlayed = 0
        self.gamesWon = 0
        self.totalPoints = 0
        self.highestGameScore = 0
        self.farkleCount = 0
        self.hotDiceCount = 0
        self.highestTurnScore = 0
        self.instantWins = 0
        self.sixOfAKindCount = 0
        self.currentWinStreak = 0
        self.bestWinStreak = 0
    }

    init(
        id: UUID,
        playerName: String,
        gamesPlayed: Int,
        gamesWon: Int,
        totalPoints: Int,
        highestGameScore: Int,
        farkleCount: Int = 0,
        hotDiceCount: Int = 0,
        highestTurnScore: Int = 0,
        instantWins: Int = 0,
        sixOfAKindCount: Int = 0,
        currentWinStreak: Int = 0,
        bestWinStreak: Int = 0
    ) {
        self.id = id
        self.playerName = playerName
        self.gamesPlayed = gamesPlayed
        self.gamesWon = gamesWon
        self.totalPoints = totalPoints
        self.highestGameScore = highestGameScore
        self.farkleCount = farkleCount
        self.hotDiceCount = hotDiceCount
        self.highestTurnScore = highestTurnScore
        self.instantWins = instantWins
        self.sixOfAKindCount = sixOfAKindCount
        self.currentWinStreak = currentWinStreak
        self.bestWinStreak = bestWinStreak
    }

    func toDomain() -> PlayerStatistics {
        PlayerStatistics(
            id: id,
            playerName: playerName,
            gamesPlayed: gamesPlayed,
            gamesWon: gamesWon,
            totalPoints: totalPoints,
            highestGameScore: highestGameScore,
            farkleCount: farkleCount,
            hotDiceCount: hotDiceCount,
            highestTurnScore: highestTurnScore,
            instantWins: instantWins,
            sixOfAKindCount: sixOfAKindCount,
            currentWinStreak: currentWinStreak,
            bestWinStreak: bestWinStreak
        )
    }

    static func from(_ statistics: PlayerStatistics) -> PlayerStatisticsRecord {
        PlayerStatisticsRecord(
            id: statistics.id,
            playerName: statistics.playerName,
            gamesPlayed: statistics.gamesPlayed,
            gamesWon: statistics.gamesWon,
            totalPoints: statistics.totalPoints,
            highestGameScore: statistics.highestGameScore,
            farkleCount: statistics.farkleCount,
            hotDiceCount: statistics.hotDiceCount,
            highestTurnScore: statistics.highestTurnScore,
            instantWins: statistics.instantWins,
            sixOfAKindCount: statistics.sixOfAKindCount,
            currentWinStreak: statistics.currentWinStreak,
            bestWinStreak: statistics.bestWinStreak
        )
    }

    func update(from statistics: PlayerStatistics) {
        self.gamesPlayed = statistics.gamesPlayed
        self.gamesWon = statistics.gamesWon
        self.totalPoints = statistics.totalPoints
        self.highestGameScore = statistics.highestGameScore
        self.farkleCount = statistics.farkleCount
        self.hotDiceCount = statistics.hotDiceCount
        self.highestTurnScore = statistics.highestTurnScore
        self.instantWins = statistics.instantWins
        self.sixOfAKindCount = statistics.sixOfAKindCount
        self.currentWinStreak = statistics.currentWinStreak
        self.bestWinStreak = statistics.bestWinStreak
    }
}
