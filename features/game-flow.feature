Feature: Game Flow
  As a Farkle player
  I want the game to manage turns and determine a winner
  So that we can play a complete game

  # Player turns
  Scenario: Game starts with first player
    Given a game with Alice, Bob, and Charlie
    Then it is Alice's turn

  Scenario: Turn advances to next player after banking
    Given a game with Alice and Bob
    And it is Alice's turn
    When Alice banks her points
    Then it is Bob's turn

  Scenario: Turn advances after farkling
    Given a game with Alice and Bob
    And it is Alice's turn
    When Alice farkles
    Then it is Bob's turn

  Scenario: Turn rotation wraps around
    Given a game with Alice and Bob
    And it is Bob's turn
    When Bob banks his points
    Then it is Alice's turn

  # Final round mechanics
  Scenario: Reaching target score triggers final round
    Given a game with Alice and Bob
    And Alice has 9000 points
    When Alice banks 1500 more points
    Then the final round begins
    And each other player gets one more turn

  Scenario: Final round gives everyone one more chance
    Given a game with Alice, Bob, and Charlie
    And Alice triggered the final round
    When Bob completes his final turn
    And Charlie completes his final turn
    Then the game ends

  Scenario: Player who triggered final round does not get extra turn
    Given a game with Alice and Bob
    And Alice triggered the final round
    When Bob completes his final turn
    Then the game ends
    And Alice does not get another turn

  # Winning conditions
  Scenario: Highest score wins after final round
    Given a game with Alice and Bob
    And Alice has 10500 points
    And Bob has 9800 points
    When the final round ends
    Then Alice wins the game

  Scenario: Player can overtake during final round
    Given a game with Alice and Bob
    And Alice triggered the final round with 10200 points
    When Bob scores 11000 points in his final turn
    Then Bob wins the game

  # Instant win
  Scenario: Rolling six ones wins instantly
    Given a game with Alice and Bob
    And it is Alice's turn
    When Alice records six ones
    Then Alice wins the game immediately
    And no final round is needed

  # Score display
  Scenario: Current player's total is visible
    Given a game with Alice and Bob
    And Alice has accumulated 5000 points
    Then Alice's total score of 5000 is displayed

  Scenario: Turn score accumulates separately from total
    Given a game with Alice and Bob
    And Alice has 5000 total points
    When Alice records combinations worth 800 this turn
    Then Alice's turn score shows 800
    And Alice's total still shows 5000
    And Alice's potential total would be 5800
