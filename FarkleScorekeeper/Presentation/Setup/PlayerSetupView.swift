import SwiftUI

struct PlayerSetupView: View {
    @State private var viewModel = PlayerSetupViewModel()
    @State private var navigateToGame = false
    @State private var expandedPlayerIndex: Int?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Stepper("Number of Players: \(viewModel.playerCount)",
                            value: $viewModel.playerCount,
                            in: 2...6)
                }

                ForEach(0..<viewModel.playerCount, id: \.self) { index in
                    Section {
                        playerRow(at: index)

                        if expandedPlayerIndex == index {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Choose Color")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                PlayerColorPickerView(selectedColor: $viewModel.playerColors[index])

                                Text("Choose Icon")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                PlayerIconPickerView(selectedIcon: $viewModel.playerIcons[index])
                            }
                            .padding(.vertical, 4)
                        }
                    } header: {
                        Text("Player \(index + 1)")
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
                GameView(playerConfigs: viewModel.playerConfigs)
            }
        }
    }

    private func playerRow(at index: Int) -> some View {
        HStack {
            Button {
                withAnimation {
                    if expandedPlayerIndex == index {
                        expandedPlayerIndex = nil
                    } else {
                        expandedPlayerIndex = index
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Circle()
                        .fill(viewModel.playerColors[index].swiftUIColor)
                        .frame(width: 32, height: 32)
                        .overlay {
                            Text(PlayerIcon.displayText(for: viewModel.playerIcons[index]) ?? "")
                                .font(.system(size: 16))
                        }

                    Image(systemName: expandedPlayerIndex == index ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Customize player \(index + 1)")
            .accessibilityIdentifier("customizePlayer\(index)")

            TextField("Player \(index + 1)", text: $viewModel.playerNames[index])
                .textContentType(.name)
                .autocorrectionDisabled()
                .accessibilityIdentifier("playerNameField\(index)")
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
