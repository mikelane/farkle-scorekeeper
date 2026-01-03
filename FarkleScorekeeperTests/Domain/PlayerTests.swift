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

    // MARK: - Color Tests

    func test_init_defaultColorIsNil() {
        let player = Player(id: UUID(), name: "Alice")

        XCTAssertNil(player.color)
    }

    func test_init_canSetColor() {
        let player = Player(id: UUID(), name: "Alice", color: .blue)

        XCTAssertEqual(player.color, .blue)
    }

    // MARK: - Icon Tests

    func test_init_defaultIconIsNil() {
        let player = Player(id: UUID(), name: "Alice")

        XCTAssertNil(player.icon)
    }

    func test_init_canSetIcon() {
        let player = Player(id: UUID(), name: "Alice", icon: "dice")

        XCTAssertEqual(player.icon, "dice")
    }

    func test_init_canSetBothColorAndIcon() {
        let player = Player(id: UUID(), name: "Alice", color: .purple, icon: "rocket")

        XCTAssertEqual(player.color, .purple)
        XCTAssertEqual(player.icon, "rocket")
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

    // MARK: - Display Color Tests

    func test_displayColor_returnsAssignedColorIfSet() {
        let player = Player(id: UUID(), name: "Alice", color: .purple)

        XCTAssertEqual(player.displayColor, .purple)
    }

    func test_displayColor_returnsDefaultColorIfNil() {
        let player = Player(id: UUID(), name: "Alice")

        XCTAssertEqual(player.displayColor, .blue)
    }

    // MARK: - Display Icon Tests

    func test_displayIcon_returnsAssignedIconIfSet() {
        let player = Player(id: UUID(), name: "Alice", icon: "rocket")

        XCTAssertEqual(player.displayIcon, "rocket")
    }

    func test_displayIcon_returnsDefaultIconIfNil() {
        let player = Player(id: UUID(), name: "Alice")

        XCTAssertEqual(player.displayIcon, "dice")
    }

    // MARK: - Display Name With Icon Tests

    func test_displayNameWithIcon_includesEmojiAndName() {
        let player = Player(id: UUID(), name: "Alice", icon: "rocket")

        XCTAssertEqual(player.displayNameWithIcon, "\u{1F680} Alice")
    }

    func test_displayNameWithIcon_usesDefaultIconWhenNil() {
        let player = Player(id: UUID(), name: "Alice")

        XCTAssertEqual(player.displayNameWithIcon, "\u{1F3B2} Alice")
    }
}
