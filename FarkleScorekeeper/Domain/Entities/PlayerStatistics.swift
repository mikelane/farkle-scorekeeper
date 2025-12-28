import Foundation
import SwiftData

@Model
final class PlayerStatistics: Sendable {
    var id: UUID
    @Attribute(.unique) var playerName: String
    var gamesPlayed: Int = 0
    var gamesWon: Int = 0
    var totalPoints: Int = 0
    var highestGameScore: Int = 0

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
    }

    func recordGameResult(score: Int, didWin: Bool) {
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
