import Foundation

enum PlayerColor: String, CaseIterable, Equatable, Hashable, Codable, Sendable {
    case blue
    case green
    case orange
    case purple
    case red
    case pink
    case teal
    case yellow

    static func `default`(forIndex index: Int) -> PlayerColor {
        let colors = PlayerColor.allCases
        return colors[index % colors.count]
    }
}
