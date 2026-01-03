import SwiftUI
import XCTest

@testable import FarkleScorekeeper

final class PlayerColorTests: XCTestCase {

    // MARK: - Available Colors Tests

    func test_allCases_hasExpectedColors() {
        let expectedColors: [PlayerColor] = [.blue, .green, .orange, .purple, .red, .pink, .teal, .yellow]

        XCTAssertEqual(PlayerColor.allCases, expectedColors)
    }

    func test_allCases_hasAtLeastSixColors() {
        XCTAssertGreaterThanOrEqual(PlayerColor.allCases.count, 6)
    }

    // MARK: - Default Colors Tests

    func test_defaultForIndex_returnsExpectedColorsInOrder() {
        XCTAssertEqual(PlayerColor.default(forIndex: 0), .blue)
        XCTAssertEqual(PlayerColor.default(forIndex: 1), .green)
        XCTAssertEqual(PlayerColor.default(forIndex: 2), .orange)
        XCTAssertEqual(PlayerColor.default(forIndex: 3), .purple)
        XCTAssertEqual(PlayerColor.default(forIndex: 4), .red)
        XCTAssertEqual(PlayerColor.default(forIndex: 5), .pink)
    }

    func test_defaultForIndex_wrapsAroundForLargeIndices() {
        let colorCount = PlayerColor.allCases.count

        XCTAssertEqual(PlayerColor.default(forIndex: colorCount), PlayerColor.default(forIndex: 0))
        XCTAssertEqual(PlayerColor.default(forIndex: colorCount + 1), PlayerColor.default(forIndex: 1))
    }

    // MARK: - Equatable Tests

    func test_colorsAreEquatable() {
        XCTAssertEqual(PlayerColor.blue, PlayerColor.blue)
        XCTAssertNotEqual(PlayerColor.blue, PlayerColor.green)
    }

    // MARK: - Hashable Tests

    func test_colorsAreHashable() {
        let colorSet: Set<PlayerColor> = [.blue, .green, .blue]

        XCTAssertEqual(colorSet.count, 2)
    }

    // MARK: - Codable Tests

    func test_colorsAreCodable() throws {
        let color = PlayerColor.purple
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        let data = try encoder.encode(color)
        let decoded = try decoder.decode(PlayerColor.self, from: data)

        XCTAssertEqual(decoded, color)
    }

    // MARK: - SwiftUI Color Conversion Tests

    func test_swiftUIColor_blueReturnsSwiftUIBlue() {
        let playerColor = PlayerColor.blue
        let swiftUIColor = playerColor.swiftUIColor

        XCTAssertEqual(swiftUIColor, Color.blue)
    }

    func test_swiftUIColor_allColorsHaveValidSwiftUIColors() {
        for playerColor in PlayerColor.allCases {
            let swiftUIColor = playerColor.swiftUIColor

            XCTAssertNotNil(swiftUIColor)
        }
    }
}
