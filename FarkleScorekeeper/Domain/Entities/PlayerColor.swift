import Foundation
import SwiftUI

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

    var swiftUIColor: Color {
        switch self {
        case .blue: return .blue
        case .green: return .green
        case .orange: return .orange
        case .purple: return .purple
        case .red: return .red
        case .pink: return .pink
        case .teal: return .teal
        case .yellow: return .yellow
        }
    }
}
