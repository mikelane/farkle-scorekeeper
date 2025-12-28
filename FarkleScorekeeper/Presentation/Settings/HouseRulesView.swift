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
        }
        .navigationTitle("House Rules")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        HouseRulesView(viewModel: HouseRulesViewModel())
    }
}
