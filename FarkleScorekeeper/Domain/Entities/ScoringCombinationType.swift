import Foundation

enum ScoringCombinationType: String, CaseIterable, Codable, Sendable {
    case singleOne
    case singleFive
    case threeOfAKind
    case fourOfAKind
    case fiveOfAKind
    case sixOfAKind
    case sixOnes
    case fullHouse
    case fullMansion
    case threePairs
    case twoTriplets
    case smallStraight
    case largeStraight
    case sixDiceFarkle

    var displayName: String {
        switch self {
        case .singleOne:
            return "Single 1"
        case .singleFive:
            return "Single 5"
        case .threeOfAKind:
            return "Three of a Kind"
        case .fourOfAKind:
            return "Four of a Kind"
        case .fiveOfAKind:
            return "Five of a Kind"
        case .sixOfAKind:
            return "Six of a Kind"
        case .sixOnes:
            return "Six 1s"
        case .fullHouse:
            return "Full House"
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

    var defaultPoints: Int {
        switch self {
        case .singleOne:
            return 100
        case .singleFive:
            return 50
        case .threeOfAKind:
            return 0 // Varies by die value, uses multiplier
        case .fourOfAKind:
            return 2000
        case .fiveOfAKind:
            return 3000
        case .sixOfAKind:
            return 10000
        case .sixOnes:
            return 0 // Instant win
        case .fullHouse:
            return 0 // Varies by triplet value
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

    var supportsCustomPoints: Bool {
        switch self {
        case .singleOne, .singleFive, .fourOfAKind, .fiveOfAKind, .sixOfAKind,
             .fullMansion, .threePairs, .twoTriplets, .smallStraight, .largeStraight, .sixDiceFarkle:
            return true
        case .threeOfAKind, .sixOnes, .fullHouse:
            return false
        }
    }
}
