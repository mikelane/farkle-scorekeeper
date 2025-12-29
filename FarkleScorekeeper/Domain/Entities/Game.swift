import Foundation

enum FinalRoundState: Equatable, Sendable {
    case notStarted
    case inProgress(triggerPlayerIndex: Int)
    case completed
}

struct Game: Sendable {
    private(set) var players: [Player]
    private(set) var currentPlayerIndex: Int = 0
    private(set) var currentTurn: Turn
    private(set) var isGameOver: Bool = false
    private(set) var winner: Player?
    let houseRules: HouseRules
    private var finalRoundTriggerPlayerIndex: Int?
    private(set) var currentDefenderIndex: Int?
    private(set) var eliminatedPlayerIndices: Set<Int> = []

    var targetScore: Int {
        houseRules.targetScore
    }

    var currentPlayer: Player {
        players[currentPlayerIndex]
    }

    var isInFinalRound: Bool {
        finalRoundTriggerPlayerIndex != nil
    }

    var finalRoundState: FinalRoundState {
        guard let triggerIndex = finalRoundTriggerPlayerIndex else {
            return .notStarted
        }
        if isGameOver {
            return .completed
        }
        return .inProgress(triggerPlayerIndex: triggerIndex)
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

    mutating func undoLastScore() {
        currentTurn.undoLastScore()
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
                    if houseRules.defendYourWin {
                        currentDefenderIndex = currentPlayerIndex
                    }
                } else if houseRules.defendYourWin {
                    updateDefenderIfOvertaken()
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

    private mutating func updateDefenderIfOvertaken() {
        guard let defenderIndex = currentDefenderIndex else { return }
        let defenderScore = players[defenderIndex].score
        let currentScore = players[currentPlayerIndex].score
        if currentScore > defenderScore {
            currentDefenderIndex = currentPlayerIndex
        }
    }

    mutating func farkle() {
        if houseRules.defendYourWin && isInFinalRound {
            eliminatedPlayerIndices.insert(currentPlayerIndex)
        }
        advanceToNextPlayer()
        checkForGameEnd()
    }

    mutating func declareInstantWin() {
        isGameOver = true
        winner = currentPlayer
    }

    private mutating func advanceToNextPlayer() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count

        if houseRules.defendYourWin && isInFinalRound {
            skipEliminatedPlayers()
        }

        currentTurn = Turn()
    }

    private mutating func skipEliminatedPlayers() {
        var attempts = 0
        while eliminatedPlayerIndices.contains(currentPlayerIndex) && attempts < players.count {
            currentPlayerIndex = (currentPlayerIndex + 1) % players.count
            attempts += 1
        }
    }

    private mutating func checkForGameEnd() {
        guard let triggerIndex = finalRoundTriggerPlayerIndex else {
            return
        }

        if houseRules.defendYourWin {
            checkDefendModeGameEnd()
        } else if currentPlayerIndex == triggerIndex {
            isGameOver = true
            winner = players.max(by: { $0.score < $1.score })
        }
    }

    private mutating func checkDefendModeGameEnd() {
        guard let defenderIndex = currentDefenderIndex else { return }

        if currentPlayerIndex == defenderIndex {
            isGameOver = true
            winner = players[defenderIndex]
        }
    }
}
