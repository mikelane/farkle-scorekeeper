import Foundation

struct Player: Identifiable, Equatable, Sendable {
    let id: UUID
    var name: String
    var score: Int = 0
    var color: PlayerColor?
    var icon: String?

    var displayColor: PlayerColor {
        color ?? .blue
    }

    var displayIcon: String {
        icon ?? PlayerIcon.default(forIndex: 0)
    }

    var displayNameWithIcon: String {
        let emoji = PlayerIcon.displayText(for: displayIcon) ?? displayIcon
        return "\(emoji) \(name)"
    }
}
