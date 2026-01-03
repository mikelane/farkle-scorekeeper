import Foundation

struct ScoringConfig: Equatable, Codable, Sendable {
    private var enabledCombinations: Set<ScoringCombinationType>
    private(set) var customPoints: [ScoringCombinationType: Int]
    var threeOfAKindMultiplier: Int

    static var standard: ScoringConfig {
        ScoringConfig(
            enabledCombinations: Set(ScoringCombinationType.allCases),
            customPoints: [:],
            threeOfAKindMultiplier: 100
        )
    }

    init(
        enabledCombinations: Set<ScoringCombinationType> = Set(ScoringCombinationType.allCases),
        customPoints: [ScoringCombinationType: Int] = [:],
        threeOfAKindMultiplier: Int = 100
    ) {
        self.enabledCombinations = enabledCombinations
        self.customPoints = customPoints
        self.threeOfAKindMultiplier = threeOfAKindMultiplier
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.enabledCombinations = try container.decodeIfPresent(
            Set<ScoringCombinationType>.self,
            forKey: .enabledCombinations
        ) ?? Set(ScoringCombinationType.allCases)
        self.customPoints = try container.decodeIfPresent(
            [ScoringCombinationType: Int].self,
            forKey: .customPoints
        ) ?? [:]
        self.threeOfAKindMultiplier = try container.decodeIfPresent(
            Int.self,
            forKey: .threeOfAKindMultiplier
        ) ?? 100
    }

    func isEnabled(_ combinationType: ScoringCombinationType) -> Bool {
        enabledCombinations.contains(combinationType)
    }

    mutating func setEnabled(_ enabled: Bool, for combinationType: ScoringCombinationType) {
        if enabled {
            enabledCombinations.insert(combinationType)
        } else {
            enabledCombinations.remove(combinationType)
        }
    }

    mutating func setCustomPoints(_ points: Int, for combinationType: ScoringCombinationType) {
        customPoints[combinationType] = points
    }

    mutating func clearCustomPoints(for combinationType: ScoringCombinationType) {
        customPoints.removeValue(forKey: combinationType)
    }

    mutating func resetToStandard() {
        enabledCombinations = Set(ScoringCombinationType.allCases)
        customPoints = [:]
        threeOfAKindMultiplier = 100
    }
}
