import Foundation

struct Game: Sendable {
    private(set) var players: [Player]
    private(set) var currentPlayerIndex: Int = 0
    private(set) var currentTurn: Turn
    private(set) var isGameOver: Bool = false
    private(set) var winner: Player?
    let houseRules: HouseRules
    private var finalRoundTriggerPlayerIndex: Int?

    var targetScore: Int {
        houseRules.targetScore
    }

    var currentPlayer: Player {
        players[currentPlayerIndex]
    }

    var isInFinalRound: Bool {
        finalRoundTriggerPlayerIndex != nil
    }

    init(playerNames: [String], targetScore: Int = 10000) {
        self.init(playerNames: playerNames, houseRules: HouseRules(targetScore: targetScore))
    }

    init(playerNames: [String], houseRules: HouseRules) {
        self.players = playerNames.map { Player(id: UUID(), name: $0) }
        self.houseRules = houseRules
        self.currentTurn = Turn()
    }

    mutating func addScore(_ combination: ScoringCombination) {
        currentTurn.addScore(combination)
    }

    mutating func bankPoints() -> Bool {
        guard currentTurn.canBank else {
            return false
        }

        players[currentPlayerIndex].score += currentTurn.score

        if players[currentPlayerIndex].score >= targetScore {
            if houseRules.finalRoundEnabled {
                if !isInFinalRound {
                    finalRoundTriggerPlayerIndex = currentPlayerIndex
                }
                advanceToNextPlayer()
                checkForGameEnd()
            } else {
                isGameOver = true
                winner = currentPlayer
            }
        } else {
            advanceToNextPlayer()
            checkForGameEnd()
        }

        return true
    }

    mutating func farkle() {
        advanceToNextPlayer()
        checkForGameEnd()
    }

    mutating func declareInstantWin() {
        isGameOver = true
        winner = currentPlayer
    }

    private mutating func advanceToNextPlayer() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
        currentTurn = Turn()
    }

    private mutating func checkForGameEnd() {
        guard let triggerIndex = finalRoundTriggerPlayerIndex else {
            return
        }

        if currentPlayerIndex == triggerIndex {
            isGameOver = true
            winner = players.max(by: { $0.score < $1.score })
        }
    }
}
