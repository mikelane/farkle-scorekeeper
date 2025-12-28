import Foundation

struct PlayerResult: Equatable, Sendable {
    let name: String
    let score: Int
    let rank: Int
}

struct GameResultsFormatter: Sendable {

    private static let sharedNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    }()

    static func formatScore(_ score: Int) -> String {
        sharedNumberFormatter.string(from: NSNumber(value: score)) ?? "\(score)"
    }

    func format(players: [PlayerResult]) -> String {
        var lines: [String] = []

        lines.append("🎲 Farkle Game Results")
        lines.append("")

        for player in players {
            let formattedScore = formatScore(player.score)
            let position = positionLabel(for: player.rank, isGameOver: true)
            lines.append("\(position): \(player.name) (\(formattedScore) pts)")
        }

        lines.append("")
        lines.append("Played with Farkle Scorekeeper")

        return lines.joined(separator: "\n")
    }

    func formatCurrentStandings(players: [PlayerResult]) -> String {
        var lines: [String] = []

        lines.append("🎲 Farkle Current Standings")
        lines.append("")

        for player in players {
            let formattedScore = formatScore(player.score)
            let position = positionLabel(for: player.rank, isGameOver: false)
            lines.append("\(position): \(player.name) (\(formattedScore) pts)")
        }

        lines.append("")
        lines.append("Played with Farkle Scorekeeper")

        return lines.joined(separator: "\n")
    }

    static func createResults(from game: Game) -> [PlayerResult] {
        let sortedPlayers = game.players.sorted { $0.score > $1.score }

        var results: [PlayerResult] = []
        var currentRank = 1
        var previousScore: Int?

        for (index, player) in sortedPlayers.enumerated() {
            if let prevScore = previousScore, player.score < prevScore {
                currentRank = index + 1
            }

            results.append(PlayerResult(
                name: player.name,
                score: player.score,
                rank: currentRank
            ))

            previousScore = player.score
        }

        return results
    }

    private func formatScore(_ score: Int) -> String {
        Self.formatScore(score)
    }

    private func positionLabel(for rank: Int, isGameOver: Bool) -> String {
        if isGameOver && rank == 1 {
            return "🏆 Winner"
        }

        return "\(rank)\(ordinalSuffix(for: rank))"
    }

    private func ordinalSuffix(for number: Int) -> String {
        let tens = (number % 100) / 10
        if tens == 1 {
            return "th"
        }
        switch number % 10 {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return "th"
        }
    }
}
