import Foundation
import Observation

@Observable
final class HouseRulesViewModel {
    private let repository: HouseRulesRepository

    var targetScore: Int {
        didSet { save() }
    }
    var finalRoundEnabled: Bool {
        didSet { save() }
    }
    var defendYourWin: Bool {
        didSet { save() }
    }

    let presetTargetScores = HouseRules.presetTargetScores

    init(repository: HouseRulesRepository = HouseRulesRepository()) {
        self.repository = repository
        let rules = repository.load()
        self.targetScore = rules.targetScore
        self.finalRoundEnabled = rules.finalRoundEnabled
        self.defendYourWin = rules.defendYourWin
    }

    private func save() {
        let rules = HouseRules(
            targetScore: targetScore,
            finalRoundEnabled: finalRoundEnabled,
            defendYourWin: defendYourWin
        )
        repository.save(rules)
    }
}
