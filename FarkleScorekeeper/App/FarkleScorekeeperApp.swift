import SwiftData
import SwiftUI

@main
struct FarkleScorekeeperApp: App {
    @State private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(themeManager.colorScheme)
                .environment(themeManager)
        }
    }
}
