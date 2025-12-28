import SwiftUI

struct ResultsCardView: View {
    let players: [PlayerResult]
    let isGameOver: Bool

    private let cardWidth: CGFloat = 350

    var body: some View {
        VStack(spacing: 0) {
            headerSection
            playersSection
            footerSection
        }
        .frame(width: cardWidth)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.15, green: 0.15, blue: 0.2), Color(red: 0.1, green: 0.1, blue: 0.15)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("🎲")
                .font(.system(size: 48))

            Text(isGameOver ? "Game Results" : "Current Standings")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
        .padding(.top, 24)
        .padding(.bottom, 16)
    }

    private var playersSection: some View {
        VStack(spacing: 12) {
            ForEach(Array(players.enumerated()), id: \.offset) { index, player in
                playerRow(player: player, isFirst: index == 0 && isGameOver)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    private func playerRow(player: PlayerResult, isFirst: Bool) -> some View {
        HStack {
            rankBadge(rank: player.rank, isWinner: isFirst)

            Text(player.name)
                .font(.headline)
                .foregroundStyle(.white)
                .lineLimit(1)

            Spacer()

            Text(formatScore(player.score))
                .font(.system(.body, design: .rounded))
                .fontWeight(.semibold)
                .foregroundStyle(isFirst ? Color.yellow : Color.white.opacity(0.9))

            Text("pts")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isFirst ? Color.yellow.opacity(0.15) : Color.white.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isFirst ? Color.yellow.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }

    private func rankBadge(rank: Int, isWinner: Bool) -> some View {
        ZStack {
            Circle()
                .fill(isWinner ? Color.yellow : Color.white.opacity(0.2))
                .frame(width: 32, height: 32)

            if isWinner {
                Text("🏆")
                    .font(.system(size: 16))
            } else {
                Text("\(rank)")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundStyle(Color.white)
            }
        }
    }

    private var footerSection: some View {
        VStack(spacing: 4) {
            Divider()
                .background(Color.white.opacity(0.1))
                .padding(.horizontal, 20)

            Text("Farkle Scorekeeper")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.5))
                .padding(.vertical, 16)
        }
    }

    private func formatScore(_ score: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: score)) ?? "\(score)"
    }
}

#Preview("Game Over - 3 Players") {
    ResultsCardView(
        players: [
            PlayerResult(name: "Alice", score: 10500, rank: 1),
            PlayerResult(name: "Bob", score: 8200, rank: 2),
            PlayerResult(name: "Charlie", score: 7100, rank: 3)
        ],
        isGameOver: true
    )
    .padding()
    .background(Color.gray)
}

#Preview("In Progress - 2 Players") {
    ResultsCardView(
        players: [
            PlayerResult(name: "Alice", score: 5000, rank: 1),
            PlayerResult(name: "Bob", score: 3000, rank: 2)
        ],
        isGameOver: false
    )
    .padding()
    .background(Color.gray)
}

#Preview("Game Over - 4 Players") {
    ResultsCardView(
        players: [
            PlayerResult(name: "Alice", score: 10500, rank: 1),
            PlayerResult(name: "Bob", score: 8200, rank: 2),
            PlayerResult(name: "Charlie", score: 7100, rank: 3),
            PlayerResult(name: "Dave", score: 5000, rank: 4)
        ],
        isGameOver: true
    )
    .padding()
    .background(Color.gray)
}
