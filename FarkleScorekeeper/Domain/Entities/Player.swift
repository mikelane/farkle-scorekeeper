import Foundation

struct Player: Identifiable, Equatable, Sendable {
    let id: UUID
    var name: String
    var score: Int = 0
}
