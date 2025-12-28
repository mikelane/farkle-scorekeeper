import XCTest

/// Base class for BDD-style UI tests.
/// Provides Given/When/Then DSL that mirrors Gherkin feature files.
///
/// Note: XCUITest runs on the main thread, so we use nonisolated(unsafe)
/// to avoid Swift 6 concurrency issues while maintaining thread safety.
class BDDTestCase: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    nonisolated(unsafe) var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }

    // MARK: - BDD DSL

    /// Records a Given step (precondition setup)
    @discardableResult
    func given(_ description: String, file: StaticString = #file, line: UInt = #line, step: () -> Void = {}) -> Self {
        XCTContext.runActivity(named: "Given \(description)") { _ in
            step()
        }
        return self
    }

    /// Records a When step (action)
    @discardableResult
    func when(_ description: String, file: StaticString = #file, line: UInt = #line, step: () -> Void = {}) -> Self {
        XCTContext.runActivity(named: "When \(description)") { _ in
            step()
        }
        return self
    }

    /// Records a Then step (assertion)
    @discardableResult
    func then(_ description: String, file: StaticString = #file, line: UInt = #line, step: () -> Void = {}) -> Self {
        XCTContext.runActivity(named: "Then \(description)") { _ in
            step()
        }
        return self
    }

    /// Records an And step (continuation of previous step type)
    @discardableResult
    func and(_ description: String, file: StaticString = #file, line: UInt = #line, step: () -> Void = {}) -> Self {
        XCTContext.runActivity(named: "And \(description)") { _ in
            step()
        }
        return self
    }
}
