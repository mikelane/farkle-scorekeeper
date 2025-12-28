import Foundation

struct HouseRules: Equatable, Codable, Sendable {
    let targetScore: Int
    let finalRoundEnabled: Bool
    let defendYourWin: Bool

    static let presetTargetScores = [5000, 7500, 10000, 15000]

    init(
        targetScore: Int = 10000,
        finalRoundEnabled: Bool = true,
        defendYourWin: Bool = false
    ) {
        self.targetScore = targetScore
        self.finalRoundEnabled = finalRoundEnabled
        self.defendYourWin = defendYourWin
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.targetScore = try container.decodeIfPresent(Int.self, forKey: .targetScore) ?? 10000
        self.finalRoundEnabled = try container.decodeIfPresent(Bool.self, forKey: .finalRoundEnabled) ?? true
        self.defendYourWin = try container.decodeIfPresent(Bool.self, forKey: .defendYourWin) ?? false
    }
}
