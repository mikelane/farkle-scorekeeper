/// Represents a scoring combination in Farkle.
/// Pure domain entity - no external dependencies.
enum ScoringCombination: Sendable, Equatable {
    case singleOne
    case singleFive
    case threeOfAKind(dieValue: Int)
    case fourOfAKind
    case fiveOfAKind
    case sixOfAKind
    case sixOnes
    case fullHouse(tripletValue: Int)
    case fullMansion
    case threePairs
    case twoTriplets
    case smallStraight
    case largeStraight
    case sixDiceFarkle

    var points: Int {
        points(using: .standard)
    }

    var isInstantWin: Bool {
        switch self {
        case .sixOnes:
            return true
        default:
            return false
        }
    }

    var diceCount: Int {
        switch self {
        case .singleOne, .singleFive:
            return 1
        case .threeOfAKind:
            return 3
        case .fourOfAKind:
            return 4
        case .fiveOfAKind, .fullHouse, .smallStraight:
            return 5
        case .sixOfAKind, .sixOnes, .fullMansion, .threePairs, .twoTriplets, .largeStraight, .sixDiceFarkle:
            return 6
        }
    }

    var requiresFirstRoll: Bool {
        switch self {
        case .sixDiceFarkle:
            return true
        default:
            return false
        }
    }

    var displayName: String {
        switch self {
        case .singleOne:
            return "Single 1"
        case .singleFive:
            return "Single 5"
        case .threeOfAKind(let dieValue):
            return "Three \(dieValue)s"
        case .fourOfAKind:
            return "Four of a Kind"
        case .fiveOfAKind:
            return "Five of a Kind"
        case .sixOfAKind:
            return "Six of a Kind"
        case .sixOnes:
            return "Six 1s!"
        case .fullHouse(let tripletValue):
            return "Full House (\(tripletValue)s)"
        case .fullMansion:
            return "Full Mansion"
        case .threePairs:
            return "Three Pairs"
        case .twoTriplets:
            return "Two Triplets"
        case .smallStraight:
            return "Small Straight"
        case .largeStraight:
            return "Large Straight"
        case .sixDiceFarkle:
            return "Six-Dice Farkle"
        }
    }

    var combinationType: ScoringCombinationType {
        switch self {
        case .singleOne:
            return .singleOne
        case .singleFive:
            return .singleFive
        case .threeOfAKind:
            return .threeOfAKind
        case .fourOfAKind:
            return .fourOfAKind
        case .fiveOfAKind:
            return .fiveOfAKind
        case .sixOfAKind:
            return .sixOfAKind
        case .sixOnes:
            return .sixOnes
        case .fullHouse:
            return .fullHouse
        case .fullMansion:
            return .fullMansion
        case .threePairs:
            return .threePairs
        case .twoTriplets:
            return .twoTriplets
        case .smallStraight:
            return .smallStraight
        case .largeStraight:
            return .largeStraight
        case .sixDiceFarkle:
            return .sixDiceFarkle
        }
    }

    func points(using config: ScoringConfig) -> Int {
        if let customPoints = config.customPoints[combinationType] {
            return customPoints
        }
        switch self {
        case .singleOne:
            return 100
        case .singleFive:
            return 50
        case .threeOfAKind(let dieValue):
            if dieValue == 1 {
                return 1000
            }
            return dieValue * config.threeOfAKindMultiplier
        case .fourOfAKind:
            return 2000
        case .fiveOfAKind:
            return 3000
        case .sixOfAKind:
            return 10000
        case .sixOnes:
            return 0
        case .fullHouse(let tripletValue):
            let tripletPoints = tripletValue == 1 ? 1000 : tripletValue * config.threeOfAKindMultiplier
            return tripletPoints + 250
        case .fullMansion:
            return 2250
        case .threePairs:
            return 1500
        case .twoTriplets:
            return 2500
        case .smallStraight, .largeStraight:
            return 1500
        case .sixDiceFarkle:
            return 500
        }
    }
}
