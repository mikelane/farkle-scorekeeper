import XCTest

@testable import FarkleScorekeeper

final class PlayerIconTests: XCTestCase {

    // MARK: - Available Icons Tests

    func test_defaultEmojis_containsExpectedCount() {
        XCTAssertGreaterThanOrEqual(PlayerIcon.defaultEmojis.count, 12)
    }

    func test_defaultEmojis_containsDiceEmoji() {
        XCTAssertTrue(PlayerIcon.defaultEmojis.contains("dice"))
    }

    func test_defaultEmojis_containsRocketEmoji() {
        XCTAssertTrue(PlayerIcon.defaultEmojis.contains("rocket"))
    }

    // MARK: - Random Icon Tests

    func test_randomIcon_returnsIconFromDefaultSet() {
        let randomIcon = PlayerIcon.randomIcon()

        XCTAssertTrue(PlayerIcon.defaultEmojis.contains(randomIcon))
    }

    func test_randomIconExcluding_excludesProvidedIcons() {
        let excludedIcons = Set(PlayerIcon.defaultEmojis.dropLast(1))
        let lastIcon = PlayerIcon.defaultEmojis.last!

        let icon = PlayerIcon.randomIcon(excluding: excludedIcons)

        XCTAssertEqual(icon, lastIcon)
    }

    func test_randomIconExcluding_returnsFirstIfAllExcluded() {
        let allExcluded = Set(PlayerIcon.defaultEmojis)

        let icon = PlayerIcon.randomIcon(excluding: allExcluded)

        XCTAssertEqual(icon, PlayerIcon.defaultEmojis.first!)
    }

    // MARK: - Default Icon Assignment Tests

    func test_defaultForIndex_returnsUniqueIconsForDifferentIndices() {
        let icon0 = PlayerIcon.default(forIndex: 0)
        let icon1 = PlayerIcon.default(forIndex: 1)
        let icon2 = PlayerIcon.default(forIndex: 2)

        XCTAssertNotEqual(icon0, icon1)
        XCTAssertNotEqual(icon1, icon2)
        XCTAssertNotEqual(icon0, icon2)
    }

    func test_defaultForIndex_wrapsAroundForLargeIndices() {
        let iconCount = PlayerIcon.defaultEmojis.count
        let icon0 = PlayerIcon.default(forIndex: 0)
        let iconWrapped = PlayerIcon.default(forIndex: iconCount)

        XCTAssertEqual(icon0, iconWrapped)
    }

    // MARK: - Display Text Tests

    func test_displayText_returnsEmojiString() {
        let displayText = PlayerIcon.displayText(for: "dice")

        XCTAssertNotNil(displayText)
        XCTAssertFalse(displayText!.isEmpty)
    }

    func test_displayText_returnsNilForUnknownIcon() {
        let displayText = PlayerIcon.displayText(for: "unknown_icon_xyz")

        XCTAssertNil(displayText)
    }
}
