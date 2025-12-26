# Farkle Scorekeeper

A beautiful iOS app for keeping score of Farkle with configurable house rules.

[![iOS](https://img.shields.io/badge/iOS-17%2B-blue)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange)](https://swift.org/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

## Features

- **Standard Farkle Scoring**: All official scoring combinations
- **Multi-Player Support**: 2-8 players
- **Game History**: Track all your games
- **Fun Statistics**: From win rates to "Greedy Gus" awards
- **Beautiful UI**: Designed for a delightful experience

## What is Farkle?

Farkle is a dice game where players roll six dice to accumulate points. The goal is to be the first to reach 10,000 points. On each turn, you must set aside scoring dice and can choose to bank your points or risk rolling again. If you roll and get no scoring dice, you "Farkle" and lose all points from that turn!

### Scoring

| Combination | Points |
|-------------|--------|
| Single 1 | 100 |
| Single 5 | 50 |
| Three 1s | 1,000 |
| Three 2s | 200 |
| Three 3s | 300 |
| Three 4s | 400 |
| Three 5s | 500 |
| Three 6s | 600 |
| Four of a kind | 2x three-of-a-kind |
| Five of a kind | 4x three-of-a-kind |
| Six of a kind | 8x three-of-a-kind |
| Straight (1-6) | 1,500 |
| Three Pairs | 1,500 |

## Requirements

- iOS 17.0+
- Xcode 15.0+

## Installation

1. Clone the repository
2. Open `FarkleScorekeeper.xcodeproj` in Xcode
3. Build and run on simulator or device

## Development

This project follows **strict Test-Driven Development (TDD)**:

1. **RED**: Write a failing test
2. **GREEN**: Write minimum code to pass
3. **REFACTOR**: Clean up while tests stay green

See [CLAUDE.md](CLAUDE.md) for architecture details and development guidelines.

## License

MIT License - see [LICENSE](LICENSE) for details.
