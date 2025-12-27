import SwiftUI

struct GameView: View {
    @State private var viewModel: GameViewModel

    init(playerNames: [String]) {
        _viewModel = State(initialValue: GameViewModel(playerNames: playerNames))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                turnHeader
                ScoreInputPadView(viewModel: viewModel)
            }
        }
        .overlay {
            if viewModel.isGameOver {
                gameOverOverlay
            }
        }
    }

    private var turnHeader: some View {
        VStack(spacing: 8) {
            Text(viewModel.currentPlayerName)
                .font(.title)
                .fontWeight(.bold)

            HStack(spacing: 24) {
                VStack {
                    Text("Turn Score")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(viewModel.turnScore)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                }

                VStack {
                    Text("Dice Left")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(viewModel.diceRemaining)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(viewModel.diceRemaining <= 2 ? .green : .primary)
                }

                VStack {
                    Text("Total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(viewModel.currentPlayerScore)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            }

            if viewModel.mustRoll && viewModel.diceRemaining > 0 {
                Text("Must continue rolling")
                    .font(.caption)
                    .foregroundStyle(.orange)
            } else if viewModel.canBank {
                Text("Can bank or continue")
                    .font(.caption)
                    .foregroundStyle(.green)
            }
        }
        .padding()
    }

    private var gameOverOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Game Over!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                if let winner = viewModel.winnerName {
                    Text("\(winner) Wins!")
                        .font(.title)
                        .foregroundStyle(.yellow)
                }
            }
        }
    }
}

#Preview {
    GameView(playerNames: ["Alice", "Bob"])
}
