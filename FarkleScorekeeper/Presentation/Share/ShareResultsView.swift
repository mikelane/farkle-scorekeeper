import SwiftUI

struct ShareResultsView: View {
    let players: [PlayerResult]
    let isGameOver: Bool

    @State private var shareImage: Image?
    @State private var renderedImage: UIImage?

    private let formatter = GameResultsFormatter()

    var body: some View {
        Menu {
            ShareLink(
                item: shareText,
                preview: SharePreview("Farkle Results", image: Image(systemName: "dice"))
            ) {
                Label("Share as Text", systemImage: "text.alignleft")
            }

            Button {
                generateAndShareImage()
            } label: {
                Label("Share as Image", systemImage: "photo")
            }
        } label: {
            Image(systemName: "square.and.arrow.up")
                .accessibilityLabel("Share Results")
        }
        .sheet(item: $renderedImage) { image in
            ShareImageSheet(image: image)
        }
    }

    private var shareText: String {
        if isGameOver {
            formatter.format(players: players)
        } else {
            formatter.formatCurrentStandings(players: players)
        }
    }

    private func generateAndShareImage() {
        let cardView = ResultsCardView(players: players, isGameOver: isGameOver)
        let renderer = ImageRenderer(content: cardView)
        renderer.scale = UIScreen.main.scale

        if let uiImage = renderer.uiImage {
            renderedImage = uiImage
        }
    }
}

extension UIImage: @retroactive Identifiable {
    public var id: Int {
        hashValue
    }
}

private struct ShareImageSheet: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()

                ShareLink(
                    item: Image(uiImage: image),
                    preview: SharePreview("Farkle Results", image: Image(uiImage: image))
                ) {
                    Label("Share Image", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
            }
            .navigationTitle("Share Results")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview("Game Over") {
    ShareResultsView(
        players: [
            PlayerResult(name: "Alice", score: 10500, rank: 1),
            PlayerResult(name: "Bob", score: 8200, rank: 2),
            PlayerResult(name: "Charlie", score: 7100, rank: 3)
        ],
        isGameOver: true
    )
}

#Preview("In Progress") {
    ShareResultsView(
        players: [
            PlayerResult(name: "Alice", score: 5000, rank: 1),
            PlayerResult(name: "Bob", score: 3000, rank: 2)
        ],
        isGameOver: false
    )
}
