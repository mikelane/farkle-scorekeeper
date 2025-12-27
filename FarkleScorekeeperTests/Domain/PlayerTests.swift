import XCTest

@testable import FarkleScorekeeper

final class PlayerTests: XCTestCase {

    // MARK: - Initialization Tests

    func test_init_createsPlayerWithProvidedName() {
        let player = Player(id: UUID(), name: "Alice")

        XCTAssertEqual(player.name, "Alice")
    }

    func test_init_defaultScoreIsZero() {
        let player = Player(id: UUID(), name: "Alice")

        XCTAssertEqual(player.score, 0)
    }

    // MARK: - Identifiable Tests

    func test_conformsToIdentifiable() {
        let playerId = UUID()
        let player: any Identifiable = Player(id: playerId, name: "Alice")

        XCTAssertEqual(player.id as? UUID, playerId)
    }

    // MARK: - Equatable Tests

    func test_playersWithSameIdAreEqual() {
        let playerId = UUID()
        let player1 = Player(id: playerId, name: "Alice")
        let player2 = Player(id: playerId, name: "Alice")

        XCTAssertEqual(player1, player2)
    }

    func test_playersWithDifferentIdsAreNotEqual() {
        let player1 = Player(id: UUID(), name: "Alice")
        let player2 = Player(id: UUID(), name: "Alice")

        XCTAssertNotEqual(player1, player2)
    }
}
