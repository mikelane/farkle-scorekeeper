import SwiftUI

struct TurnHistoryView: View {
    let scoringHistory: [ScoringCombination]
    @State private var isExpanded: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            historyHeader
            if isExpanded {
                historyContent
            }
        }
        .padding()
        .background(AppColors.TurnHistory.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .accessibilityIdentifier("turnHistorySection")
    }

    private var historyHeader: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded.toggle()
            }
        } label: {
            HStack {
                Text("Turn History")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("turnHistoryToggle")
    }

    @ViewBuilder
    private var historyContent: some View {
        if scoringHistory.isEmpty {
            Text("No combinations scored yet")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .accessibilityIdentifier("emptyHistoryMessage")
        } else {
            VStack(spacing: 4) {
                ForEach(Array(scoringHistory.enumerated()), id: \.offset) { index, combination in
                    TurnHistoryRowView(combination: combination)
                        .accessibilityIdentifier("historyRow_\(index)")
                }
                Divider()
                runningTotalRow
            }
        }
    }

    private var runningTotalRow: some View {
        HStack {
            Text("Running Total")
                .font(.subheadline)
                .fontWeight(.semibold)
            Spacer()
            Text("\(runningTotal)")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.Score.turnScore)
        }
        .accessibilityIdentifier("runningTotalRow")
    }

    private var runningTotal: Int {
        scoringHistory.reduce(0) { $0 + $1.points }
    }
}

struct TurnHistoryRowView: View {
    let combination: ScoringCombination

    var body: some View {
        HStack {
            Text(combination.displayName)
                .font(.subheadline)
            Spacer()
            Text("+\(combination.points)")
                .font(.subheadline)
                .foregroundStyle(AppColors.Score.turnScore)
        }
    }
}

#Preview("With History") {
    TurnHistoryView(scoringHistory: [
        .singleOne,
        .singleFive,
        .threeOfAKind(dieValue: 3)
    ])
    .padding()
}

#Preview("Empty") {
    TurnHistoryView(scoringHistory: [])
        .padding()
}
