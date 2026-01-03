import Foundation
import Observation

@Observable
final class HouseRulesViewModel {
    private let repository: HouseRulesRepository
    private var scoringConfig: ScoringConfig

    var targetScore: Int {
        didSet { save() }
    }
    var finalRoundEnabled: Bool {
        didSet { save() }
    }
    var defendYourWin: Bool {
        didSet { save() }
    }
    var threeOfAKindMultiplier: Int {
        get { scoringConfig.threeOfAKindMultiplier }
        set {
            scoringConfig.threeOfAKindMultiplier = newValue
            save()
        }
    }

    let presetTargetScores = HouseRules.presetTargetScores

    init(repository: HouseRulesRepository = HouseRulesRepository()) {
        self.repository = repository
        let rules = repository.load()
        self.targetScore = rules.targetScore
        self.finalRoundEnabled = rules.finalRoundEnabled
        self.defendYourWin = rules.defendYourWin
        self.scoringConfig = rules.scoringConfig
    }

    func isCombinationEnabled(_ combinationType: ScoringCombinationType) -> Bool {
        scoringConfig.isEnabled(combinationType)
    }

    func setCombinationEnabled(_ enabled: Bool, for combinationType: ScoringCombinationType) {
        scoringConfig.setEnabled(enabled, for: combinationType)
        save()
    }

    func customPoints(for combinationType: ScoringCombinationType) -> Int? {
        scoringConfig.customPoints[combinationType]
    }

    func setCustomPoints(_ points: Int, for combinationType: ScoringCombinationType) {
        scoringConfig.setCustomPoints(points, for: combinationType)
        save()
    }

    func clearCustomPoints(for combinationType: ScoringCombinationType) {
        scoringConfig.clearCustomPoints(for: combinationType)
        save()
    }

    func resetScoringConfigToStandard() {
        scoringConfig.resetToStandard()
        save()
    }

    private func save() {
        let rules = HouseRules(
            targetScore: targetScore,
            finalRoundEnabled: finalRoundEnabled,
            defendYourWin: defendYourWin,
            scoringConfig: scoringConfig
        )
        repository.save(rules)
    }
}
