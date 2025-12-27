# Farkle Scorekeeper

iOS app for keeping score of Farkle with configurable house rules.

## Tech Stack

- **Platform**: iOS 26+
- **UI**: SwiftUI
- **Persistence**: SwiftData
- **Architecture**: Hexagonal Architecture (Ports & Adapters) with MVVM presentation
- **Testing**: XCTest with strict TDD

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      ADAPTERS (Outside)                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │  SwiftUI     │  │  SwiftData   │  │  UserDefaults    │   │
│  │  Views       │  │  Repository  │  │  ConfigAdapter   │   │
│  └──────┬───────┘  └──────┬───────┘  └────────┬─────────┘   │
├─────────┼─────────────────┼────────────────────┼────────────┤
│         │      PORTS (Interfaces)              │            │
│         ▼                 ▼                    ▼            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐   │
│  │ ScoreInput   │  │ GameRepo     │  │ ScoringConfig    │   │
│  │ Port         │  │ Protocol     │  │ Protocol         │   │
│  └──────┬───────┘  └──────┬───────┘  └────────┬─────────┘   │
├─────────┼─────────────────┼────────────────────┼────────────┤
│         ▼                 ▼                    ▼            │
│                    DOMAIN (Core)                            │
│  ┌────────────────────────────────────────────────────┐     │
│  │  ScoringCombination  │  Turn  │  Game  │  Player   │     │
│  │  (pure Swift, zero dependencies)                   │     │
│  └────────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────┘
        Dependencies point INWARD →
```

## UX Design: Score Input Pad

Users roll physical dice, then tap buttons to record what they scored:

```
┌─────────────────────────────────────────┐
│         Turn Score: 450                 │
│         (3 dice remaining)              │
├─────────────────────────────────────────┤
│   ┌─────┐  ┌─────┐  ┌─────┐  ┌─────┐   │
│   │ 50  │  │ 100 │  │ 150 │  │ 200 │   │
│   │ (5) │  │ (1) │  │(5+1)│  │(1+1)│   │
│   └─────┘  └─────┘  └─────┘  └─────┘   │
│                                         │
│   ┌───────────────┐  ┌───────────────┐  │
│   │  3 of a Kind  │  │  4 of a Kind  │  │
│   │   (pick die)  │  │    (2000)     │  │
│   └───────────────┘  └───────────────┘  │
│                                         │
│   ┌─────────┐ ┌─────────┐ ┌─────────┐  │
│   │ Straight│ │3 Pairs  │ │ 2 Trips │  │
│   └─────────┘ └─────────┘ └─────────┘  │
│                                         │
├─────────────────────────────────────────┤
│  [  FARKLE!  ]     [  BANK  ]          │
└─────────────────────────────────────────┘
```

## Scoring Rules

| Combination | Dice | Points | Notes |
|-------------|------|--------|-------|
| Single 1 | 1 | 100 | |
| Single 5 | 1 | 50 | |
| 3 of a Kind | 3 | 100×die (1s=1000) | |
| 4 of a Kind | 4 | 2000 | Flat value |
| 5 of a Kind | 5 | 3000 | Flat value |
| 6 of a Kind (2-6) | 6 | 10000 | |
| 6 of a Kind (1s) | 6 | INSTANT WIN | |
| Full House (3+2) | 5 | 3-of-kind + 250 | |
| Full Mansion (4+2) | 6 | 2250 | |
| Three Pairs | 6 | 1500 | |
| Two Triplets | 6 | 2500 | |
| Small Straight | 5 | 1500 | 1-5 or 2-6 |
| Large Straight | 6 | 1500 | 1-2-3-4-5-6 |
| Six-Dice Farkle | 6 | 500 | First roll only |

## House Rules

### Hot Dice (Mandatory)
- When all 6 dice are used for scoring → MUST roll all 6 again
- Cannot bank on Hot Dice
- Turn score carries forward

### Banking Restrictions
| Dice Remaining | Action |
|----------------|--------|
| 0 (Hot Dice) | MUST roll all 6 |
| 5, 4, 3 | MUST continue rolling |
| 2 or 1 | CAN bank OR continue |

## TDD Requirements (MANDATORY)

### Uncle Bob's 3 Rules of TDD
1. **No production code unless it makes a failing test pass**
2. **No more test code than sufficient to fail** (compilation errors count)
3. **No more production code than sufficient to pass the one failing test**

### Pragmatic Refactoring
4. **Refactor only when tests are green**

### Coverage Requirements
- **100% Line Coverage** - Every line of production code must be executed by tests
- **100% Branch Coverage** - Every branch (if/else, switch cases) must be tested
- **90% Mutation Coverage** - At least 90% of mutants must be killed

### Testing Pyramid (Google Test Sizes)
| Size | % | Scope | iOS Mapping |
|------|---|-------|-------------|
| Small | 75-80% | Single process, no I/O | Unit tests (domain, pure logic) |
| Medium | 10-15% | Multi-process, localhost I/O | Integration (SwiftData, ViewModels) |
| Large/XL | 5-10% | External resources | UI tests, E2E flows |

## Commands

```bash
# Build
xcodebuild -scheme FarkleScorekeeper -destination 'platform=iOS Simulator,name=iPhone 16 Pro'

# Test with coverage
xcodebuild test -scheme FarkleScorekeeper -destination 'platform=iOS Simulator,name=iPhone 16 Pro' -enableCodeCoverage YES

# Regenerate project
xcodegen generate
```

## Project Structure

```
FarkleScorekeeper/
├── App/
│   └── FarkleScorekeeperApp.swift
├── Domain/
│   ├── Entities/
│   │   ├── ScoringCombination.swift
│   │   ├── Turn.swift
│   │   ├── Game.swift
│   │   └── Player.swift
│   ├── Ports/
│   │   ├── GameRepositoryProtocol.swift
│   │   └── ScoringConfigProtocol.swift
│   └── UseCases/
│       ├── AddScoreUseCase.swift
│       ├── BankPointsUseCase.swift
│       └── FarkleUseCase.swift
├── Data/
│   ├── Models/
│   │   ├── GameRecord.swift
│   │   └── PlayerStats.swift
│   └── Adapters/
│       ├── SwiftDataGameRepository.swift
│       └── UserDefaultsScoringConfig.swift
├── Presentation/
│   ├── Game/
│   │   ├── GameView.swift
│   │   ├── GameViewModel.swift
│   │   └── ScoreInputPadView.swift
│   ├── Setup/
│   │   └── SetupView.swift
│   └── Stats/
│       └── StatsView.swift
└── Resources/
    └── Assets.xcassets
```
