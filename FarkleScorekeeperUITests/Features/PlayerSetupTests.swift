import XCTest

final class PlayerSetupTests: BDDTestCase {

    func test_colorPicker_selectingRedChangesColorToRed() {
        given("the app is launched") {
            app.launch()
        }

        when("I tap to customize Player 1") {
            let customizeButton = app.buttons["customizePlayer0"]
            XCTAssertTrue(customizeButton.waitForExistence(timeout: 5), "Customize button should exist")
            customizeButton.tap()
        }

        and("I tap the red color") {
            let redButton = app.buttons["red"]
            XCTAssertTrue(redButton.waitForExistence(timeout: 5), "Red color button should exist")
            redButton.tap()
        }

        then("the selected color indicator shows on red") {
            let redButton = app.buttons["red"]
            XCTAssertTrue(redButton.isSelected, "Red button should be selected")
        }
    }

    func test_colorPicker_selectingPurpleChangesColorToPurple() {
        given("the app is launched") {
            app.launch()
        }

        when("I tap to customize Player 1") {
            let customizeButton = app.buttons["customizePlayer0"]
            XCTAssertTrue(customizeButton.waitForExistence(timeout: 5), "Customize button should exist")
            customizeButton.tap()
        }

        and("I tap the purple color") {
            let purpleButton = app.buttons["purple"]
            XCTAssertTrue(purpleButton.waitForExistence(timeout: 5), "Purple color button should exist")
            purpleButton.tap()
        }

        then("the selected color indicator shows on purple") {
            let purpleButton = app.buttons["purple"]
            XCTAssertTrue(purpleButton.isSelected, "Purple button should be selected")
        }
    }

    func test_colorPicker_doesNotSelectYellowWhenTappingRed() {
        given("the app is launched") {
            app.launch()
        }

        when("I tap to customize Player 1") {
            let customizeButton = app.buttons["customizePlayer0"]
            XCTAssertTrue(customizeButton.waitForExistence(timeout: 5), "Customize button should exist")
            customizeButton.tap()
        }

        and("I tap the red color") {
            let redButton = app.buttons["red"]
            XCTAssertTrue(redButton.waitForExistence(timeout: 5), "Red color button should exist")
            redButton.tap()
        }

        then("yellow is NOT selected") {
            let yellowButton = app.buttons["yellow"]
            XCTAssertFalse(yellowButton.isSelected, "Yellow button should NOT be selected when tapping red")
        }

        and("red IS selected") {
            let redButton = app.buttons["red"]
            XCTAssertTrue(redButton.isSelected, "Red button should be selected")
        }
    }
}
