import Foundation

@Observable
final class GameViewModel {
    private var game: Game

    var currentPlayerName: String {
        game.currentPlayer.name
    }

    var currentPlayerScore: Int {
        game.currentPlayer.score
    }

    var turnScore: Int {
        game.currentTurn.score
    }

    var diceRemaining: Int {
        game.currentTurn.diceRemaining
    }

    var canBank: Bool {
        game.currentTurn.canBank
    }

    var mustRoll: Bool {
        game.currentTurn.mustRoll
    }

    var turnScoringHistory: [ScoringCombination] {
        game.currentTurn.scoringHistory
    }

    var canUndo: Bool {
        game.currentTurn.canUndo
    }

    var isGameOver: Bool {
        game.isGameOver
    }

    var winnerName: String? {
        game.winner?.name
    }

    init(playerNames: [String]) {
        self.game = Game(playerNames: playerNames)
    }

    func addScore(_ combination: ScoringCombination) {
        game.addScore(combination)
    }

    @discardableResult
    func bank() -> Bool {
        game.bankPoints()
    }

    func farkle() {
        game.farkle()
    }

    func undo() {
        game.undoLastScore()
    }

    func isCombinationAvailable(_ combination: ScoringCombination) -> Bool {
        guard diceRemaining >= combination.diceCount else {
            return false
        }
        if combination.requiresFirstRoll && !game.currentTurn.isFirstRoll {
            return false
        }
        return true
    }
}
