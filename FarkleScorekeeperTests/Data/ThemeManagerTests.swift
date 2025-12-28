import XCTest
@testable import FarkleScorekeeper

final class ThemeManagerTests: XCTestCase {
    var sut: ThemeManager!
    var mockDefaults: UserDefaults!

    override func setUp() {
        super.setUp()
        mockDefaults = UserDefaults(suiteName: "ThemeManagerTests")!
        mockDefaults.removePersistentDomain(forName: "ThemeManagerTests")
        sut = ThemeManager(userDefaults: mockDefaults)
    }

    override func tearDown() {
        mockDefaults.removePersistentDomain(forName: "ThemeManagerTests")
        mockDefaults = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - AppearancePreference Tests

    func test_appearancePreference_defaultsToSystem() {
        XCTAssertEqual(sut.appearancePreference, .system)
    }

    func test_appearancePreference_persistsLightValue() {
        sut.appearancePreference = .light

        let newManager = ThemeManager(userDefaults: mockDefaults)
        XCTAssertEqual(newManager.appearancePreference, .light)
    }

    func test_appearancePreference_persistsDarkValue() {
        sut.appearancePreference = .dark

        let newManager = ThemeManager(userDefaults: mockDefaults)
        XCTAssertEqual(newManager.appearancePreference, .dark)
    }

    func test_appearancePreference_persistsSystemValue() {
        sut.appearancePreference = .dark
        sut.appearancePreference = .system

        let newManager = ThemeManager(userDefaults: mockDefaults)
        XCTAssertEqual(newManager.appearancePreference, .system)
    }

    // MARK: - ColorScheme Tests

    func test_colorScheme_returnsNilForSystemPreference() {
        sut.appearancePreference = .system
        XCTAssertNil(sut.colorScheme)
    }

    func test_colorScheme_returnsLightForLightPreference() {
        sut.appearancePreference = .light
        XCTAssertEqual(sut.colorScheme, .light)
    }

    func test_colorScheme_returnsDarkForDarkPreference() {
        sut.appearancePreference = .dark
        XCTAssertEqual(sut.colorScheme, .dark)
    }

}

// MARK: - AppearancePreference Tests

final class AppearancePreferenceTests: XCTestCase {

    func test_allCases_containsThreeOptions() {
        XCTAssertEqual(AppearancePreference.allCases.count, 3)
    }

    func test_allCases_containsSystemLightDark() {
        XCTAssertTrue(AppearancePreference.allCases.contains(.system))
        XCTAssertTrue(AppearancePreference.allCases.contains(.light))
        XCTAssertTrue(AppearancePreference.allCases.contains(.dark))
    }

    func test_displayName_system_returnsCorrectString() {
        XCTAssertEqual(AppearancePreference.system.displayName, "System")
    }

    func test_displayName_light_returnsCorrectString() {
        XCTAssertEqual(AppearancePreference.light.displayName, "Always Light")
    }

    func test_displayName_dark_returnsCorrectString() {
        XCTAssertEqual(AppearancePreference.dark.displayName, "Always Dark")
    }

    func test_iconName_system_returnsCorrectSymbol() {
        XCTAssertEqual(AppearancePreference.system.iconName, "circle.lefthalf.filled")
    }

    func test_iconName_light_returnsCorrectSymbol() {
        XCTAssertEqual(AppearancePreference.light.iconName, "sun.max.fill")
    }

    func test_iconName_dark_returnsCorrectSymbol() {
        XCTAssertEqual(AppearancePreference.dark.iconName, "moon.fill")
    }
}
