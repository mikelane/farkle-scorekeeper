/// Represents a player's turn in Farkle.
/// Pure domain entity - no external dependencies.
struct Turn: Sendable {
    var score: Int = 0
    var diceRemaining: Int = 6
    var isFirstRoll: Bool = true
    private(set) var scoringHistory: [ScoringCombination] = []
    private var hotDiceTriggeredIndices: Set<Int> = []

    var canBank: Bool {
        diceRemaining <= 2 && diceRemaining > 0
    }

    var canUndo: Bool {
        !scoringHistory.isEmpty
    }

    var mustRoll: Bool {
        diceRemaining == 0 || diceRemaining > 2
    }

    mutating func addScore(_ combination: ScoringCombination) {
        score += combination.points
        diceRemaining -= combination.diceCount
        isFirstRoll = false
        scoringHistory.append(combination)

        if diceRemaining == 0 {
            hotDiceTriggeredIndices.insert(scoringHistory.count - 1)
            hotDice()
        }
    }

    mutating func farkle() {
        score = 0
    }

    mutating func hotDice() {
        diceRemaining = 6
    }

    mutating func undoLastScore() {
        guard !scoringHistory.isEmpty else {
            return
        }

        let undoIndex = scoringHistory.count - 1
        let lastCombination = scoringHistory.removeLast()

        score -= lastCombination.points

        if hotDiceTriggeredIndices.contains(undoIndex) {
            hotDiceTriggeredIndices.remove(undoIndex)
            diceRemaining = 0
        }

        diceRemaining += lastCombination.diceCount

        if scoringHistory.isEmpty {
            isFirstRoll = true
        }
    }
}
