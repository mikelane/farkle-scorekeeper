import SwiftUI

struct GameView: View {
    @State private var viewModel: GameViewModel

    init(playerNames: [String]) {
        _viewModel = State(initialValue: GameViewModel(playerNames: playerNames))
    }

    init(playerConfigs: [PlayerConfig]) {
        _viewModel = State(initialValue: GameViewModel(playerConfigs: playerConfigs))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if viewModel.isInFinalRound,
                   let triggerName = viewModel.finalRoundTriggerPlayerName,
                   let score = viewModel.scoreToBeat {
                    FinalRoundBannerView(
                        triggerPlayerName: triggerName,
                        scoreToBeat: score
                    )
                }
                turnHeader
                TurnHistoryView(scoringHistory: viewModel.turnScoringHistory)
                    .padding(.horizontal)
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
            if viewModel.currentPlayerFinalRoundStatus == .challenger {
                Text("Last Chance!")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.FinalRound.scoreToBeat)
                    .accessibilityIdentifier("lastChanceIndicator")
            }

            HStack(spacing: 8) {
                Circle()
                    .fill(viewModel.currentPlayerColor.swiftUIColor)
                    .frame(width: 40, height: 40)
                    .overlay {
                        Text(PlayerIcon.displayText(for: viewModel.currentPlayerIcon) ?? "")
                            .font(.title3)
                    }

                Text(viewModel.currentPlayerName)
                    .font(.title)
                    .fontWeight(.bold)
                    .accessibilityIdentifier("currentPlayer")
            }

            HStack(spacing: 24) {
                VStack {
                    Text("Turn Score")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(viewModel.turnScore)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(AppColors.Score.turnScore)
                        .accessibilityIdentifier("turnScore")
                }

                VStack {
                    Text("Dice Left")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(viewModel.diceRemaining)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(viewModel.diceRemaining <= 2 ? AppColors.Score.canBank : .primary)
                        .accessibilityIdentifier("diceRemaining")
                }

                VStack {
                    Text("Total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(viewModel.currentPlayerScore)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .accessibilityIdentifier("totalScore")
                }
            }

            if viewModel.mustRoll && viewModel.diceRemaining > 0 {
                Text("Must continue rolling")
                    .font(.caption)
                    .foregroundStyle(AppColors.Score.mustRoll)
            } else if viewModel.canBank {
                Text("Can bank or continue")
                    .font(.caption)
                    .foregroundStyle(AppColors.Score.canBank)
            }
        }
        .padding()
    }

    private var gameOverOverlay: some View {
        ZStack {
            AppColors.GameOver.overlayBackground
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Game Over!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                if let winner = viewModel.winnerName {
                    Text("\(winner) Wins!")
                        .font(.title)
                        .foregroundStyle(AppColors.GameOver.winnerHighlight)
                }
            }
        }
    }
}

#Preview {
    GameView(playerNames: ["Alice", "Bob"])
}
