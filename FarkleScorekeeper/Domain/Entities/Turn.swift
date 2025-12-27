/// Represents a player's turn in Farkle.
/// Pure domain entity - no external dependencies.
struct Turn: Sendable {
    var score: Int = 0
    var diceRemaining: Int = 6
    var isFirstRoll: Bool = true
    private(set) var scoringHistory: [ScoringCombination] = []

    var canBank: Bool {
        diceRemaining <= 2 && diceRemaining > 0
    }

    var mustRoll: Bool {
        diceRemaining == 0 || diceRemaining > 2
    }

    mutating func addScore(_ combination: ScoringCombination) {
        score += combination.points
        diceRemaining -= combination.diceCount
        isFirstRoll = false
        scoringHistory.append(combination)
    }

    mutating func farkle() {
        score = 0
    }

    mutating func hotDice() {
        diceRemaining = 6
    }
}
