import Foundation
import Observation

@Observable
final class PlayerSetupViewModel {
    private let recentNamesRepository: RecentPlayerNamesRepository

    var playerCount: Int = 2 {
        didSet { adjustPlayerNames() }
    }
    var playerNames: [String] = ["", ""]
    private(set) var recentNames: [String] = []

    var finalPlayerNames: [String] {
        playerNames.enumerated().map { index, name in
            let trimmed = name.trimmingCharacters(in: .whitespaces)
            return trimmed.isEmpty ? "Player \(index + 1)" : trimmed
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

    private func adjustPlayerNames() {
        while playerNames.count < playerCount {
            playerNames.append("")
        }
        while playerNames.count > playerCount {
            playerNames.removeLast()
        }
    }
}
