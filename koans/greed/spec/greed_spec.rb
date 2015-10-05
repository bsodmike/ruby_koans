# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.

require File.expand_path(File.dirname(__FILE__) + '../../../neo')
require File.expand_path(File.dirname(__FILE__) + '/../lib/greed')

class GreedSpec < Neo::Koan

  def test_greed_classes_load_correctly
    assert_equal true, Greed.is_a?(Module)
    assert_equal true, Greed::DiceSet.is_a?(Class)
  end

end


class Greed::DiceSetSpec < Neo::Koan
  def test_can_create_a_dice_set
    dice = Greed::DiceSet.new
    assert_not_nil dice
  end

  def test_rolling_the_dice_returns_a_set_of_integers_between_1_and_6
    dice = Greed::DiceSet.new

    dice.roll(5)
    assert dice.values.is_a?(Array), "should be an array"
    assert_equal 5, dice.values.size
    dice.values.each do |value|
      assert value >= 1 && value <= 6, "value #{value} must be between 1 and 6"
    end
  end

  def test_dice_values_do_not_change_unless_explicitly_rolled
    dice = Greed::DiceSet.new
    dice.roll(5)
    first_time = dice.values
    second_time = dice.values
    assert_equal first_time, second_time
  end

  def test_dice_values_should_change_between_rolls
    dice = Greed::DiceSet.new

    dice.roll(5)
    first_time = dice.values

    dice.roll(5)
    second_time = dice.values

    assert_not_equal first_time, second_time,
      "Two rolls should not be equal"

    # THINK ABOUT IT:
    #
    # If the rolls are random, then it is possible (although not
    # likely) that two consecutive rolls are equal.  What would be a
    # better way to test this?
    #
    # Compare object IDs to ensure, the result set for each roll is indeed
    # unique.

    assert_not_equal [first_time, first_time.object_id],
      [second_time, second_time.object_id], "Two rolls should not be equal"
  end

  def test_you_can_roll_different_numbers_of_dice
    dice = Greed::DiceSet.new

    dice.roll(3)
    assert_equal 3, dice.values.size

    dice.roll(1)
    assert_equal 1, dice.values.size
  end

end

# Greed is a dice game where you roll up to five dice to accumulate
# points.  The following "score" function will be used to calculate the
# score of a single roll of the dice.
#
# A greed roll is scored as follows:
#
# * A set of three ones is 1000 points
#
# * A set of three numbers (other than ones) is worth 100 times the
#   number. (e.g. three fives is 500 points).
#
# * A one (that is not part of a set of three) is worth 100 points.
#
# * A five (that is not part of a set of three) is worth 50 points.
#
# * Everything else is worth 0 points.
#
#
# Examples:
#
# score([1,1,1,5,1]) => 1150 points
# score([2,3,4,6,2]) => 0 points
# score([3,4,5,3,3]) => 350 points
# score([1,5,1,2,4]) => 250 points
#
# More scoring examples are given in the tests below:
#
# Your goal is to write the score method.

class Greed::ScorableSpec < Neo::Koan
  def test_score_of_an_empty_list_is_zero
    assert_equal 0, Greed::Scorable.score([])
  end

  def test_score_of_a_single_roll_of_5_is_50
    assert_equal 50, Greed::Scorable.score([5])
  end

  def test_score_of_a_single_roll_of_1_is_100
    assert_equal 100, Greed::Scorable.score([1])
  end

  def test_score_of_multiple_1s_and_5s_is_the_sum_of_individual_scores
    assert_equal 300, Greed::Scorable.score([1,5,5,1])
  end

  def test_score_of_single_2s_3s_4s_and_6s_are_zero
    assert_equal 0, Greed::Scorable.score([2,3,4,6])
  end

  def test_score_of_a_triple_1_is_1000
    assert_equal 1000, Greed::Scorable.score([1,1,1])
  end

  def test_score_of_other_triples_is_100x
    assert_equal 200, Greed::Scorable.score([2,2,2])
    assert_equal 300, Greed::Scorable.score([3,3,3])
    assert_equal 400, Greed::Scorable.score([4,4,4])
    assert_equal 500, Greed::Scorable.score([5,5,5])
    assert_equal 600, Greed::Scorable.score([6,6,6])
  end

  def test_score_of_mixed_is_sum
    assert_equal 250, Greed::Scorable.score([2,5,2,2,3])
    assert_equal 550, Greed::Scorable.score([5,5,5,5])
    assert_equal 1100, Greed::Scorable.score([1,1,1,1])
    assert_equal 1200, Greed::Scorable.score([1,1,1,1,1])
    assert_equal 1150, Greed::Scorable.score([1,1,1,5,1])
  end

end
