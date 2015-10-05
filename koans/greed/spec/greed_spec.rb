# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.

require File.expand_path(File.dirname(__FILE__) + '../../../neo')
require File.expand_path(File.dirname(__FILE__) + '/../lib/greed')
Dir.glob(File.dirname(__FILE__) + "/greed/*", &method(:require))

class GreedSpec < Neo::Koan

  def test_greed_classes_load_correctly
    assert_equal true, Greed.is_a?(Module)
    assert_equal true, Greed::DiceSet.is_a?(Class)
    assert_equal true, Greed::Scorable.is_a?(Class)
  end

  Player = Greed::Player

  def test_running_a_game_records_turns
    game = Greed::Game.new(Player.new("mike"), Player.new("bob"))
    game.play

    turns = game.instance_variable_get(:@turns)
    first_turn = turns[0]
    first_turn_score = first_turn[1][:score]

    assert first_turn_score > 0
  end

  def test_running_a_game_and_printing_turn_totals
    game = Greed::Game.new(Player.new("mike"), Player.new("bob"))
    game.play

    assert_match /Score/, game.turn_totals
  end

end

