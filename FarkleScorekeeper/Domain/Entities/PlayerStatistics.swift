import Foundation

struct PlayerStatistics: Equatable, Sendable, Identifiable {
    let id: UUID
    let playerName: String
    var gamesPlayed: Int
    var gamesWon: Int
    var totalPoints: Int
    var highestGameScore: Int

    var winRate: Double {
        guard gamesPlayed > 0 else { return 0.0 }
        return Double(gamesWon) / Double(gamesPlayed)
    }

    var averageScore: Int {
        guard gamesPlayed > 0 else { return 0 }
        return totalPoints / gamesPlayed
    }

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

    mutating func recordGameResult(score: Int, didWin: Bool) {
        gamesPlayed += 1
        if didWin {
            gamesWon += 1
        }
        totalPoints += score
        if score > highestGameScore {
            highestGameScore = score
        }
    }
}
