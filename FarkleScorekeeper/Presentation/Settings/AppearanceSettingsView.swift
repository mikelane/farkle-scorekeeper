import SwiftUI

struct AppearanceSettingsView: View {
    @Bindable var themeManager: ThemeManager

    var body: some View {
        Form {
            Section {
                ForEach(AppearancePreference.allCases, id: \.self) { preference in
                    AppearanceOptionRow(
                        preference: preference,
                        isSelected: themeManager.appearancePreference == preference
                    ) {
                        themeManager.appearancePreference = preference
                    }
                }
            } header: {
                Text("Appearance")
            } footer: {
                Text("Choose how Farkle Scorekeeper appears. System follows your device settings.")
            }

            Section {
                Toggle(isOn: $themeManager.highContrastEnabled) {
                    Label("High Contrast", systemImage: "circle.hexagongrid.fill")
                }
            } header: {
                Text("Accessibility")
            } footer: {
                Text("Increases contrast and adds borders for better visibility.")
            }
        }
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AppearanceOptionRow: View {
    let preference: AppearancePreference
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Label(preference.displayName, systemImage: preference.iconName)
                    .foregroundStyle(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.blue)
                        .fontWeight(.semibold)
                }
            }
        }
        .accessibilityIdentifier("appearance_\(preference.rawValue)")
    }
}

#Preview {
    NavigationStack {
        AppearanceSettingsView(themeManager: ThemeManager())
    }
}
