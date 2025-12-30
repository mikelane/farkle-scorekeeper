import SwiftUI

struct PlayerSetupView: View {
    @State private var viewModel = PlayerSetupViewModel()
    @State private var navigateToGame = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Stepper("Number of Players: \(viewModel.playerCount)",
                            value: $viewModel.playerCount,
                            in: 2...6)
                }

                Section("Player Names") {
                    ForEach(0..<viewModel.playerCount, id: \.self) { index in
                        TextField("Player \(index + 1)", text: $viewModel.playerNames[index])
                            .textContentType(.name)
                            .autocorrectionDisabled()
                            .accessibilityIdentifier("playerNameField\(index)")
                    }
                }

                if !viewModel.suggestedNames.isEmpty {
                    Section("Recent Players") {
                        ForEach(viewModel.suggestedNames, id: \.self) { name in
                            Button(name) {
                                fillNextEmptySlot(with: name)
                            }
                            .foregroundStyle(.primary)
                        }
                    }
                }

                if let message = viewModel.validationMessage {
                    Section {
                        Text(message)
                            .foregroundStyle(.red)
                            .font(.caption)
                            .accessibilityIdentifier("validationMessage")
                    }
                }
            }
            .navigationTitle("New Game")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Start Game") {
                        startGame()
                    }
                    .disabled(!viewModel.canStartGame)
                    .accessibilityIdentifier("startGameButton")
                }
            }
            .navigationDestination(isPresented: $navigateToGame) {
                GameView(playerNames: viewModel.finalPlayerNames)
            }
        }
    }

    private func fillNextEmptySlot(with name: String) {
        if let emptyIndex = viewModel.playerNames.firstIndex(where: { $0.trimmingCharacters(in: .whitespaces).isEmpty }) {
            viewModel.playerNames[emptyIndex] = name
        }
    }

    private func startGame() {
        viewModel.saveRecentNames()
        navigateToGame = true
    }
}

#Preview {
    PlayerSetupView()
}
