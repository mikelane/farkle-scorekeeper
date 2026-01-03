import Foundation

struct PlayerStatistics: Equatable, Sendable, Identifiable {
    let id: UUID
    let playerName: String
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

    mutating func recordGameResult(score: Int, didWin: Bool) {
        gamesPlayed += 1
        if didWin {
            gamesWon += 1
            currentWinStreak += 1
            if currentWinStreak > bestWinStreak {
                bestWinStreak = currentWinStreak
            }
        } else {
            currentWinStreak = 0
        }
        totalPoints += score
        if score > highestGameScore {
            highestGameScore = score
        }
    }

    mutating func recordFarkle() {
        farkleCount += 1
    }

    mutating func recordHotDice() {
        hotDiceCount += 1
    }

    mutating func recordTurnCompletion(turnScore: Int) {
        if turnScore > highestTurnScore {
            highestTurnScore = turnScore
        }
    }

    mutating func recordScoringCombination(_ combination: ScoringCombination) {
        switch combination {
        case .sixOfAKind:
            sixOfAKindCount += 1
        case .sixOnes:
            instantWins += 1
        default:
            break
        }
    }
}
