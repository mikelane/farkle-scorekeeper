import SwiftUI

struct FinalRoundBannerView: View {
    let triggerPlayerName: String
    let scoreToBeat: Int

    var body: some View {
        VStack(spacing: 8) {
            Text("Final Round!")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(AppColors.FinalRound.bannerText)
                .accessibilityIdentifier("finalRoundTitle")

            Text("\(triggerPlayerName) reached \(scoreToBeat)")
                .font(.subheadline)
                .foregroundStyle(AppColors.FinalRound.bannerText.opacity(0.9))
                .accessibilityIdentifier("finalRoundSubtitle")

            HStack(spacing: 4) {
                Text("Score to beat:")
                    .font(.caption)
                    .foregroundStyle(AppColors.FinalRound.bannerText.opacity(0.8))

                Text("\(scoreToBeat)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.FinalRound.bannerText)
            }
            .accessibilityIdentifier("scoreToBeat")
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(AppColors.FinalRound.bannerBackground)
        .accessibilityIdentifier("finalRoundBanner")
    }
}

#Preview("Final Round Banner") {
    FinalRoundBannerView(
        triggerPlayerName: "Alice",
        scoreToBeat: 10200
    )
}
