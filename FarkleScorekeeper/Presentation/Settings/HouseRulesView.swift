import SwiftUI

struct HouseRulesView: View {
    @Bindable var viewModel: HouseRulesViewModel

    var body: some View {
        Form {
            Section {
                Picker("Target Score", selection: $viewModel.targetScore) {
                    ForEach(viewModel.presetTargetScores, id: \.self) { score in
                        Text("\(score.formatted())").tag(score)
                    }
                }
                .accessibilityIdentifier("targetScorePicker")
            } header: {
                Text("Win Condition")
            } footer: {
                Text("The score a player must reach to trigger the end of the game.")
            }

            Section {
                Toggle("Final Round", isOn: $viewModel.finalRoundEnabled)
                    .accessibilityIdentifier("finalRoundToggle")

                Toggle("Defend Your Win", isOn: $viewModel.defendYourWin)
                    .accessibilityIdentifier("defendYourWinToggle")
            } header: {
                Text("End Game Rules")
            } footer: {
                Text("Final Round allows other players one last turn after someone reaches the target score. Defend Your Win requires the leading player to survive one more round.")
            }

            Section {
                ForEach(ScoringCombinationType.allCases, id: \.self) { combinationType in
                    CombinationToggleRow(
                        combinationType: combinationType,
                        viewModel: viewModel
                    )
                }
            } header: {
                Text("Scoring Combinations")
            } footer: {
                Text("Enable or disable specific scoring combinations.")
            }

            Section {
                Stepper(
                    "Three of a Kind: \(viewModel.threeOfAKindMultiplier)x",
                    value: Binding(
                        get: { viewModel.threeOfAKindMultiplier },
                        set: { viewModel.threeOfAKindMultiplier = $0 }
                    ),
                    in: 50...200,
                    step: 50
                )
                .accessibilityIdentifier("threeOfAKindMultiplierStepper")
            } header: {
                Text("Three of a Kind Multiplier")
            } footer: {
                Text("Standard is 100x (e.g., three 4s = 400 points). Lower for easier games.")
            }

            Section {
                Button("Reset to Standard") {
                    viewModel.resetScoringConfigToStandard()
                }
                .accessibilityIdentifier("resetToStandardButton")
            }
        }
        .navigationTitle("House Rules")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CombinationToggleRow: View {
    let combinationType: ScoringCombinationType
    let viewModel: HouseRulesViewModel

    var body: some View {
        Toggle(isOn: Binding(
            get: { viewModel.isCombinationEnabled(combinationType) },
            set: { viewModel.setCombinationEnabled($0, for: combinationType) }
        )) {
            VStack(alignment: .leading) {
                Text(combinationType.displayName)
                if combinationType.defaultPoints > 0 {
                    Text("\(combinationType.defaultPoints) pts")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .accessibilityIdentifier("\(combinationType.rawValue)Toggle")
    }
}

#Preview {
    NavigationStack {
        HouseRulesView(viewModel: HouseRulesViewModel())
    }
}
