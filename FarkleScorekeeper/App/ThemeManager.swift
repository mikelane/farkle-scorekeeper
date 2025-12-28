import SwiftUI

enum AppearancePreference: String, CaseIterable {
    case system
    case light
    case dark

    var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Always Light"
        case .dark: return "Always Dark"
        }
    }

    var iconName: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }
}

@Observable
final class ThemeManager {
    private let userDefaults: UserDefaults
    private let appearanceKey = "appearancePreference"
    private let highContrastKey = "highContrastEnabled"

    var appearancePreference: AppearancePreference {
        didSet {
            userDefaults.set(appearancePreference.rawValue, forKey: appearanceKey)
        }
    }

    var highContrastEnabled: Bool {
        didSet {
            userDefaults.set(highContrastEnabled, forKey: highContrastKey)
        }
    }

    var colorScheme: ColorScheme? {
        switch appearancePreference {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults

        if let storedValue = userDefaults.string(forKey: appearanceKey),
           let preference = AppearancePreference(rawValue: storedValue) {
            self.appearancePreference = preference
        } else {
            self.appearancePreference = .system
        }

        self.highContrastEnabled = userDefaults.bool(forKey: highContrastKey)
    }
}
