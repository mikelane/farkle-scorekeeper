import SwiftUI

struct PlayerColorPickerView: View {
    let selectedColor: PlayerColor
    let onSelect: (PlayerColor) -> Void

    private let columns = [
        GridItem(.adaptive(minimum: 44))
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(PlayerColor.allCases, id: \.self) { color in
                Button {
                    onSelect(color)
                } label: {
                    Circle()
                        .fill(color.swiftUIColor)
                        .frame(width: 44, height: 44)
                        .overlay {
                            if selectedColor == color {
                                Circle()
                                    .strokeBorder(.white, lineWidth: 3)
                            }
                        }
                        .shadow(color: selectedColor == color ? color.swiftUIColor.opacity(0.5) : .clear, radius: 4)
                }
                .buttonStyle(.borderless)
                .accessibilityLabel(color.rawValue)
                .accessibilityAddTraits(selectedColor == color ? .isSelected : [])
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var color: PlayerColor = .blue

        var body: some View {
            VStack {
                Text("Selected: \(color.rawValue)")
                PlayerColorPickerView(selectedColor: color) { newColor in
                    color = newColor
                }
            }
            .padding()
        }
    }

    return PreviewWrapper()
}
