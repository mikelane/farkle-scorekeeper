Feature: Managing a Turn
  As a Farkle player
  I want to manage my turn by banking or continuing
  So that I can maximize my score while avoiding farkles

  Background:
    Given a game with Alice and Bob
    And it is Alice's turn

  # Banking behavior
  Scenario: Banking adds turn score to total
    Given Alice has recorded four of a kind worth 2000
    When Alice banks her points
    Then Alice's total score is 2000
    And it becomes Bob's turn

  Scenario: Cannot bank with too many dice remaining
    Given Alice has recorded a single one
    Then Alice cannot bank yet
    And Alice must continue rolling

  Scenario: Can bank when in the safe zone
    Given Alice has recorded four of a kind worth 2000
    Then Alice can bank her points
    And Alice can also continue rolling

  # Farkling behavior
  Scenario: Farkling loses turn score
    Given Alice has recorded combinations worth 500
    When Alice farkles
    Then Alice's turn score is lost
    And Alice's total score remains unchanged
    And it becomes Bob's turn

  Scenario: Farkling on first roll
    When Alice farkles on her first roll
    Then Alice scores nothing
    And it becomes Bob's turn

  # Hot dice behavior
  Scenario: Using all dice triggers hot dice
    Given Alice has recorded a large straight using all 6 dice
    Then Alice has 6 dice to roll again
    And Alice's turn score is preserved

  Scenario: Hot dice allows continued scoring
    Given Alice has recorded a large straight using all 6 dice
    When Alice records a single one on her next roll
    Then Alice's turn score is 1600
    And Alice has 5 dice remaining

  # Six dice farkle (special first roll combination)
  Scenario: Recording six dice farkle on first roll
    When Alice records a six dice farkle
    Then Alice's turn score is 500
    And Alice has 6 dice remaining

  Scenario: Six dice farkle unavailable after first roll
    Given Alice has already rolled once this turn
    Then Alice cannot record a six dice farkle

  # Turn state indicators
  Scenario: New turn starts with six dice
    Then Alice has 6 dice remaining
    And Alice's turn score is 0

  Scenario: Must roll indicator with many dice
    Given Alice has recorded a single one
    Then Alice must continue rolling
    And Alice has 5 dice remaining

  Scenario: Safe zone with two dice
    Given Alice has recorded four of a kind
    Then Alice can choose to bank or continue
    And Alice has 2 dice remaining

  Scenario: Safe zone with one die
    Given Alice has recorded five of a kind
    Then Alice can choose to bank or continue
    And Alice has 1 die remaining
