import Foundation

final class RecentPlayerNamesRepository: @unchecked Sendable {
    static let storageKey = "recentPlayerNames"

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func load() -> [String] {
        userDefaults.array(forKey: Self.storageKey) as? [String] ?? []
    }

    func save(_ names: [String]) {
        userDefaults.set(names, forKey: Self.storageKey)
    }
}
