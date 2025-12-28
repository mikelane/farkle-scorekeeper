import Foundation

final class HouseRulesRepository: @unchecked Sendable {
    static let storageKey = "houseRules"

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func load() -> HouseRules {
        guard let data = userDefaults.data(forKey: Self.storageKey),
              let rules = try? JSONDecoder().decode(HouseRules.self, from: data)
        else {
            return HouseRules()
        }
        return rules
    }

    func save(_ rules: HouseRules) {
        guard let data = try? JSONEncoder().encode(rules) else {
            return
        }
        userDefaults.set(data, forKey: Self.storageKey)
    }

    func reset() {
        userDefaults.removeObject(forKey: Self.storageKey)
    }
}
