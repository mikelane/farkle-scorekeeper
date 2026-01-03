import SwiftUI

struct PlayerIconPickerView: View {
    let selectedIcon: String
    let onSelect: (String) -> Void

    private let columns = [
        GridItem(.adaptive(minimum: 44))
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(PlayerIcon.defaultEmojis, id: \.self) { iconName in
                Button {
                    onSelect(iconName)
                } label: {
                    Text(PlayerIcon.displayText(for: iconName) ?? iconName)
                        .font(.title2)
                        .frame(width: 44, height: 44)
                        .background {
                            if selectedIcon == iconName {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.accentColor.opacity(0.2))
                            }
                        }
                        .overlay {
                            if selectedIcon == iconName {
                                RoundedRectangle(cornerRadius: 8)
                                    .strokeBorder(Color.accentColor, lineWidth: 2)
                            }
                        }
                }
                .accessibilityLabel(iconName)
                .accessibilityAddTraits(selectedIcon == iconName ? .isSelected : [])
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var icon: String = "dice"

        var body: some View {
            VStack {
                Text("Selected: \(PlayerIcon.displayText(for: icon) ?? icon)")
                PlayerIconPickerView(selectedIcon: icon) { newIcon in
                    icon = newIcon
                }
            }
            .padding()
        }
    }

    return PreviewWrapper()
}
