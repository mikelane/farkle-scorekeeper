# Farkle Scorekeeper

iOS app for keeping score of Farkle with configurable house rules.

## Tech Stack

- **Platform**: iOS 17+
- **UI**: SwiftUI
- **Persistence**: SwiftData
- **Architecture**: Clean Architecture with MVVM presentation
- **Testing**: XCTest with strict TDD

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                   Presentation                       │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │
│  │   Views     │  │ ViewModels  │  │  Navigation │  │
│  └─────────────┘  └─────────────┘  └─────────────┘  │
├─────────────────────────────────────────────────────┤
│                     Domain                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │
│  │  Entities   │  │  Use Cases  │  │   Engine    │  │
│  │  (Models)   │  │  (Actions)  │  │  (Scoring)  │  │
│  └─────────────┘  └─────────────┘  └─────────────┘  │
├─────────────────────────────────────────────────────┤
│                      Data                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │
│  │ SwiftData   │  │ Repositories│  │   Mappers   │  │
│  │   Models    │  │             │  │             │  │
│  └─────────────┘  └─────────────┘  └─────────────┘  │
└─────────────────────────────────────────────────────┘
```

## Domain Model

### Core Entities

- **Die**: Single die value (1-6)
- **DiceSet**: Collection of dice with scoring analysis
- **ScoringCombination**: Represents a valid scoring combination
- **Turn**: A player's turn with rolls, held dice, and accumulated score
- **Game**: Current game state with players, scores, and turn history
- **Player**: Player identity and current game score

### Scoring Engine (Pure Functions)

The scoring engine is the heart of the app - pure functions with no side effects:

```swift
// Core scoring function - determines all valid scoring combinations
func findScoringCombinations(dice: DiceSet) -> [ScoringCombination]

// Calculate total points for selected dice
func calculateScore(for combinations: [ScoringCombination]) -> Int

// Determine if a roll is a Farkle (no scoring dice)
func isFarkle(dice: DiceSet) -> Bool

// Check if all dice scored (Hot Dice)
func isHotDice(dice: DiceSet, selected: DiceSet) -> Bool
```

### Standard Farkle Scoring Rules (MVP)

| Combination | Points |
|-------------|--------|
| Single 1 | 100 |
| Single 5 | 50 |
| Three 1s | 1000 |
| Three 2s | 200 |
| Three 3s | 300 |
| Three 4s | 400 |
| Three 5s | 500 |
| Three 6s | 600 |
| Four of a kind | 2x three-of-a-kind |
| Five of a kind | 4x three-of-a-kind |
| Six of a kind | 8x three-of-a-kind |
| 1-2-3-4-5-6 (Straight) | 1500 |
| Three pairs | 1500 |

### Game Flow

1. Player rolls all 6 dice
2. Must set aside at least one scoring die
3. Can bank points and end turn, OR
4. Can roll remaining dice for more points
5. If no scoring dice on a roll = FARKLE (lose turn's points)
6. If all 6 dice score = HOT DICE (roll all 6 again, keep points)
7. First to target score (default 10,000) wins
8. Final round: all other players get one more turn to beat winner

## Stats Tracking

### Standard Stats
- Games played / won / lost
- Win percentage
- Highest single-turn score
- Highest game score
- Total points scored (lifetime)
- Average points per game

### Fun Stats
- **Farkle Count**: Total farkles across all games
- **Hot Dice Streak**: Longest consecutive hot dice in one turn
- **Comeback Kid**: Games won after being 2000+ points behind
- **Risk Taker**: Average dice kept before banking
- **Greedy Gus**: Times farkled after already having 300+ points in turn
- **Lucky Number**: Which die value appears most often for this player
- **Clutch Factor**: Points scored in final rounds

## Project Structure

```
FarkleScorekeeper/
├── App/
│   └── FarkleScorekeeperApp.swift
├── Domain/
│   ├── Entities/
│   │   ├── Die.swift
│   │   ├── DiceSet.swift
│   │   ├── ScoringCombination.swift
│   │   ├── Turn.swift
│   │   ├── Game.swift
│   │   └── Player.swift
│   ├── Engine/
│   │   └── ScoringEngine.swift
│   └── UseCases/
│       ├── StartGameUseCase.swift
│       ├── RollDiceUseCase.swift
│       ├── SelectDiceUseCase.swift
│       └── BankPointsUseCase.swift
├── Data/
│   ├── Models/
│   │   ├── GameRecord.swift
│   │   └── PlayerStats.swift
│   └── Repositories/
│       ├── GameRepository.swift
│       └── StatsRepository.swift
├── Presentation/
│   ├── Game/
│   │   ├── GameView.swift
│   │   ├── GameViewModel.swift
│   │   ├── DiceView.swift
│   │   └── ScoreboardView.swift
│   ├── Setup/
│   │   ├── SetupView.swift
│   │   └── PlayerSetupView.swift
│   ├── Stats/
│   │   ├── StatsView.swift
│   │   └── StatsViewModel.swift
│   └── Components/
│       ├── DieView.swift
│       └── PlayerScoreCard.swift
└── Resources/
    └── Assets.xcassets
```

## TDD Workflow

Every feature follows strict TDD:

1. **RED**: Write a failing test for the smallest piece of functionality
2. **GREEN**: Write minimum code to make it pass
3. **REFACTOR**: Clean up while tests stay green

### Testing Strategy

- **Unit Tests**: Domain layer (ScoringEngine, entities)
- **Integration Tests**: Use cases with repositories
- **UI Tests**: Critical user flows

### Test File Organization

```
FarkleScorekeeperTests/
├── Domain/
│   ├── ScoringEngineTests.swift
│   ├── DiceSetTests.swift
│   └── GameTests.swift
├── Data/
│   └── RepositoryTests.swift
└── Presentation/
    └── ViewModelTests.swift
```

## Commands

```bash
# Build
xcodebuild -scheme FarkleScorekeeper -destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# Test
xcodebuild test -scheme FarkleScorekeeper -destination 'platform=iOS Simulator,name=iPhone 15 Pro'

# Format (if SwiftFormat installed)
swiftformat .
```

## MVP Scope

### Phase 1: Core Scoring Engine
- [ ] Die and DiceSet entities
- [ ] ScoringCombination entity
- [ ] ScoringEngine with all standard rules
- [ ] 100% test coverage for scoring logic

### Phase 2: Game Logic
- [ ] Turn management
- [ ] Game state machine
- [ ] Player management
- [ ] Win condition detection

### Phase 3: Persistence
- [ ] SwiftData models
- [ ] Game history storage
- [ ] Stats calculation and storage

### Phase 4: UI
- [ ] Game setup screen
- [ ] Main game view with dice
- [ ] Scoreboard
- [ ] Stats dashboard

### Phase 5: Polish
- [ ] Animations
- [ ] Haptics
- [ ] Sound effects (optional)
- [ ] App Store assets
