/// Represents a scoring combination in Farkle.
/// Pure domain entity - no external dependencies.
enum ScoringCombination {
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
        switch self {
        case .singleOne:
            return 100
        case .singleFive:
            return 50
        case .threeOfAKind(let dieValue):
            return dieValue == 1 ? 1000 : dieValue * 100
        case .fourOfAKind:
            return 2000
        case .fiveOfAKind:
            return 3000
        case .sixOfAKind:
            return 10000
        case .sixOnes:
            return 0 // Instant win, points don't matter
        case .fullHouse(let tripletValue):
            let tripletPoints = tripletValue == 1 ? 1000 : tripletValue * 100
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
}
