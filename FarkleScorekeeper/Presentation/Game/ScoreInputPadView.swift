import SwiftUI

struct ScoreInputPadView: View {
    @Bindable var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 16) {
            singleDiceCombinations
            threeOfAKindSection
            multiDiceCombinations
            sixDiceCombinations
            actionButtons
        }
        .padding()
        .id("\(viewModel.diceRemaining)-\(viewModel.turnScore)")
    }

    private var singleDiceCombinations: some View {
        HStack(spacing: 12) {
            CombinationButton(
                title: "50",
                subtitle: "Single 5",
                isEnabled: viewModel.isCombinationAvailable(.singleFive)
            ) {
                viewModel.addScore(.singleFive)
            }

            CombinationButton(
                title: "100",
                subtitle: "Single 1",
                isEnabled: viewModel.isCombinationAvailable(.singleOne)
            ) {
                viewModel.addScore(.singleOne)
            }
        }
    }

    private var threeOfAKindSection: some View {
        VStack(spacing: 8) {
            Text("Three of a Kind")
                .font(.headline)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(1...6, id: \.self) { dieValue in
                    let combination = ScoringCombination.threeOfAKind(dieValue: dieValue)
                    CombinationButton(
                        title: "\(combination.points)",
                        subtitle: "3x\(dieValue)",
                        isEnabled: viewModel.isCombinationAvailable(combination)
                    ) {
                        viewModel.addScore(combination)
                    }
                }
            }
        }
    }

    private var multiDiceCombinations: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                CombinationButton(
                    title: "2000",
                    subtitle: "4 of a Kind",
                    isEnabled: viewModel.isCombinationAvailable(.fourOfAKind)
                ) {
                    viewModel.addScore(.fourOfAKind)
                }

                CombinationButton(
                    title: "3000",
                    subtitle: "5 of a Kind",
                    isEnabled: viewModel.isCombinationAvailable(.fiveOfAKind)
                ) {
                    viewModel.addScore(.fiveOfAKind)
                }
            }

            HStack(spacing: 12) {
                CombinationButton(
                    title: "1500",
                    subtitle: "Small Straight",
                    isEnabled: viewModel.isCombinationAvailable(.smallStraight)
                ) {
                    viewModel.addScore(.smallStraight)
                }

                fullHouseMenu
            }
        }
    }

    private var fullHouseMenu: some View {
        Menu {
            ForEach(1...6, id: \.self) { tripletValue in
                let combination = ScoringCombination.fullHouse(tripletValue: tripletValue)
                Button("\(combination.points) (3x\(tripletValue) + pair)") {
                    viewModel.addScore(combination)
                }
                .disabled(!viewModel.isCombinationAvailable(combination))
            }
        } label: {
            CombinationButtonLabel(
                title: "Full House",
                subtitle: "3+2",
                isEnabled: viewModel.isCombinationAvailable(.fullHouse(tripletValue: 1))
            )
        }
        .disabled(!viewModel.isCombinationAvailable(.fullHouse(tripletValue: 1)))
    }

    private var sixDiceCombinations: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                CombinationButton(
                    title: "10000",
                    subtitle: "6 of a Kind",
                    isEnabled: viewModel.isCombinationAvailable(.sixOfAKind)
                ) {
                    viewModel.addScore(.sixOfAKind)
                }

                CombinationButton(
                    title: "WIN!",
                    subtitle: "6 Ones",
                    isEnabled: viewModel.isCombinationAvailable(.sixOnes)
                ) {
                    viewModel.addScore(.sixOnes)
                }
            }

            HStack(spacing: 12) {
                CombinationButton(
                    title: "1500",
                    subtitle: "Large Straight",
                    isEnabled: viewModel.isCombinationAvailable(.largeStraight)
                ) {
                    viewModel.addScore(.largeStraight)
                }

                CombinationButton(
                    title: "1500",
                    subtitle: "Three Pairs",
                    isEnabled: viewModel.isCombinationAvailable(.threePairs)
                ) {
                    viewModel.addScore(.threePairs)
                }
            }

            HStack(spacing: 12) {
                CombinationButton(
                    title: "2500",
                    subtitle: "Two Triplets",
                    isEnabled: viewModel.isCombinationAvailable(.twoTriplets)
                ) {
                    viewModel.addScore(.twoTriplets)
                }

                CombinationButton(
                    title: "2250",
                    subtitle: "Full Mansion",
                    isEnabled: viewModel.isCombinationAvailable(.fullMansion)
                ) {
                    viewModel.addScore(.fullMansion)
                }
            }

            CombinationButton(
                title: "500",
                subtitle: "Six-Dice Farkle",
                isEnabled: viewModel.isCombinationAvailable(.sixDiceFarkle)
            ) {
                viewModel.addScore(.sixDiceFarkle)
            }
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 16) {
            Button {
                viewModel.farkle()
            } label: {
                Text("FARKLE!")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.farkleButton)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .accessibilityIdentifier("farkleButton")

            Button {
                viewModel.bank()
            } label: {
                Text("BANK")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.canBank ? Color.bankEnabled : AppColors.Button.bankDisabledBackground)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(!viewModel.canBank)
            .accessibilityIdentifier("bankButton")
        }
    }
}

struct CombinationButton: View {
    let title: String
    let subtitle: String
    let isEnabled: Bool
    var accessibilityId: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            CombinationButtonLabel(title: title, subtitle: subtitle, isEnabled: isEnabled)
        }
        .disabled(!isEnabled)
        .accessibilityIdentifier(accessibilityId ?? subtitle)
    }
}

struct CombinationButtonLabel: View {
    let title: String
    let subtitle: String
    let isEnabled: Bool

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            Text(subtitle)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(isEnabled ? Color.buttonEnabled : Color.buttonDisabled)
        .foregroundStyle(isEnabled ? AppColors.Button.enabledForeground : AppColors.Button.disabledForeground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ScoreInputPadView(viewModel: GameViewModel(playerNames: ["Alice", "Bob"]))
}
