Feature: Recording Dice Combinations
  As a Farkle player
  I want to record the scoring dice from my roll
  So that my turn score accumulates correctly

  Background:
    Given a game with Alice and Bob
    And it is Alice's turn

  # Single dice combinations
  Scenario: Recording a single one
    When Alice records a single one
    Then Alice's turn score is 100
    And Alice has 5 dice remaining

  Scenario: Recording a single five
    When Alice records a single five
    Then Alice's turn score is 50
    And Alice has 5 dice remaining

  # Three of a kind combinations
  Scenario: Recording three ones
    When Alice records three ones
    Then Alice's turn score is 1000
    And Alice has 3 dice remaining

  Scenario Outline: Recording three of a kind
    When Alice records three <die_value>s
    Then Alice's turn score is <points>
    And Alice has 3 dice remaining

    Examples:
      | die_value | points |
      | two       | 200    |
      | three     | 300    |
      | four      | 400    |
      | five      | 500    |
      | six       | 600    |

  # Multi-dice combinations
  Scenario: Recording four of a kind
    When Alice records four of a kind
    Then Alice's turn score is 2000
    And Alice has 2 dice remaining

  Scenario: Recording five of a kind
    When Alice records five of a kind
    Then Alice's turn score is 3000
    And Alice has 1 die remaining

  Scenario: Recording six of a kind
    When Alice records six of a kind
    Then Alice's turn score is 10000
    And Alice has 6 dice remaining

  # Straight combinations
  Scenario: Recording a small straight
    When Alice records a small straight
    Then Alice's turn score is 1500
    And Alice has 1 die remaining

  Scenario: Recording a large straight
    When Alice records a large straight
    Then Alice's turn score is 1500
    And Alice has 6 dice remaining

  # Full house combinations
  Scenario: Recording a full house with three ones
    When Alice records a full house with three ones
    Then Alice's turn score is 1250
    And Alice has 1 die remaining

  Scenario: Recording a full house with three twos
    When Alice records a full house with three twos
    Then Alice's turn score is 450
    And Alice has 1 die remaining

  # Six dice combinations
  Scenario: Recording three pairs
    When Alice records three pairs
    Then Alice's turn score is 1500
    And Alice has 6 dice remaining

  Scenario: Recording two triplets
    When Alice records two triplets
    Then Alice's turn score is 2500
    And Alice has 6 dice remaining

  Scenario: Recording a full mansion
    When Alice records a full mansion
    Then Alice's turn score is 2250
    And Alice has 6 dice remaining

  # Accumulating scores
  Scenario: Recording multiple combinations in one turn
    When Alice records a single one
    And Alice records a single five
    Then Alice's turn score is 150
    And Alice has 4 dice remaining

  Scenario: Recording combinations across multiple rolls
    When Alice records three twos
    And Alice records a single one
    Then Alice's turn score is 300
    And Alice has 2 dice remaining
