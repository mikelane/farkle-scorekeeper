import Foundation
import Observation

struct PlayerConfig: Equatable, Sendable {
    var name: String
    var color: PlayerColor
    var icon: String
}

@Observable
final class PlayerSetupViewModel {
    private let recentNamesRepository: RecentPlayerNamesRepository

    var playerCount: Int = 2 {
        didSet { adjustPlayerData() }
    }
    var playerNames: [String] = ["", ""]
    var playerColors: [PlayerColor] = [PlayerColor.default(forIndex: 0), PlayerColor.default(forIndex: 1)]
    var playerIcons: [String] = [PlayerIcon.default(forIndex: 0), PlayerIcon.default(forIndex: 1)]
    private(set) var recentNames: [String] = []

    var finalPlayerNames: [String] {
        playerNames.enumerated().map { index, name in
            let trimmed = name.trimmingCharacters(in: .whitespaces)
            return trimmed.isEmpty ? "Player \(index + 1)" : trimmed
        }
    }

    var playerConfigs: [PlayerConfig] {
        (0..<playerCount).map { index in
            let name = playerNames[index].trimmingCharacters(in: .whitespaces)
            let finalName = name.isEmpty ? "Player \(index + 1)" : name
            return PlayerConfig(
                name: finalName,
                color: playerColors[index],
                icon: playerIcons[index]
            )
        }
    }

    var canStartGame: Bool {
        let trimmedNames = playerNames.map { $0.trimmingCharacters(in: .whitespaces) }
        let filledCount = trimmedNames.filter { !$0.isEmpty }.count
        return filledCount == 0 || filledCount == playerCount
    }

    var validationMessage: String? {
        canStartGame ? nil : "Please enter names for all players or leave all blank"
    }

    var suggestedNames: [String] {
        recentNames
    }

    init(recentNamesRepository: RecentPlayerNamesRepository = RecentPlayerNamesRepository()) {
        self.recentNamesRepository = recentNamesRepository
        self.recentNames = recentNamesRepository.load()
    }

    func saveRecentNames() {
        let namesToSave = playerNames
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        recentNamesRepository.save(namesToSave)
    }

    func setPlayerColor(at index: Int, to color: PlayerColor) {
        guard index >= 0, index < playerColors.count else { return }
        playerColors[index] = color
    }

    func setPlayerIcon(at index: Int, to icon: String) {
        guard index >= 0, index < playerIcons.count else { return }
        playerIcons[index] = icon
    }

    private func adjustPlayerData() {
        adjustPlayerNames()
        adjustPlayerColors()
        adjustPlayerIcons()
    }

    private func adjustPlayerNames() {
        while playerNames.count < playerCount {
            playerNames.append("")
        }
        while playerNames.count > playerCount {
            playerNames.removeLast()
        }
    }

    private func adjustPlayerColors() {
        while playerColors.count < playerCount {
            playerColors.append(PlayerColor.default(forIndex: playerColors.count))
        }
        while playerColors.count > playerCount {
            playerColors.removeLast()
        }
    }

    private func adjustPlayerIcons() {
        while playerIcons.count < playerCount {
            playerIcons.append(PlayerIcon.default(forIndex: playerIcons.count))
        }
        while playerIcons.count > playerCount {
            playerIcons.removeLast()
        }
    }
}
