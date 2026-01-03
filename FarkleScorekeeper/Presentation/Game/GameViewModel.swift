import Foundation

enum FinalRoundPlayerStatus: Equatable, Sendable {
    case normal
    case defending
    case challenger
}

struct PlayerDisplayInfo: Equatable, Sendable {
    let name: String
    let score: Int
    let status: FinalRoundPlayerStatus
    let isCurrentPlayer: Bool
    let color: PlayerColor
    let icon: String
}

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

    var isInFinalRound: Bool {
        game.isInFinalRound
    }

    var finalRoundTriggerPlayerName: String? {
        switch game.finalRoundState {
        case .notStarted, .completed:
            return nil
        case .inProgress(let triggerPlayerIndex):
            return game.players[triggerPlayerIndex].name
        }
    }

    var targetScore: Int {
        game.targetScore
    }

    var currentPlayerFinalRoundStatus: FinalRoundPlayerStatus {
        switch game.finalRoundState {
        case .notStarted, .completed:
            return .normal
        case .inProgress(let triggerPlayerIndex):
            if game.currentPlayerIndex == triggerPlayerIndex {
                return .defending
            }
            return .challenger
        }
    }

    var scoreToBeat: Int? {
        switch game.finalRoundState {
        case .notStarted, .completed:
            return nil
        case .inProgress(let triggerPlayerIndex):
            return game.players[triggerPlayerIndex].score
        }
    }

    var winnerName: String? {
        game.winner?.name
    }

    var playersInfo: [PlayerDisplayInfo] {
        game.players.enumerated().map { index, player in
            let status: FinalRoundPlayerStatus
            switch game.finalRoundState {
            case .notStarted, .completed:
                status = .normal
            case .inProgress(let triggerPlayerIndex):
                status = index == triggerPlayerIndex ? .defending : .challenger
            }
            return PlayerDisplayInfo(
                name: player.name,
                score: player.score,
                status: status,
                isCurrentPlayer: index == game.currentPlayerIndex,
                color: player.displayColor,
                icon: player.displayIcon
            )
        }
    }

    var currentPlayerColor: PlayerColor {
        game.currentPlayer.displayColor
    }

    var currentPlayerIcon: String {
        game.currentPlayer.displayIcon
    }

    var currentPlayerDisplayName: String {
        game.currentPlayer.displayNameWithIcon
    }

    init(playerNames: [String]) {
        self.game = Game(playerNames: playerNames)
    }

    init(playerConfigs: [PlayerConfig]) {
        self.game = Game(playerConfigs: playerConfigs)
    }

    init(playerNames: [String], houseRules: HouseRules) {
        self.game = Game(playerNames: playerNames, houseRules: houseRules)
    }

    init(playerConfigs: [PlayerConfig], houseRules: HouseRules) {
        self.game = Game(playerConfigs: playerConfigs, houseRules: houseRules)
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
        guard game.houseRules.scoringConfig.isEnabled(combination.combinationType) else {
            return false
        }
        guard diceRemaining >= combination.diceCount else {
            return false
        }
        if combination.requiresFirstRoll && !game.currentTurn.isFirstRoll {
            return false
        }
        return true
    }
}
