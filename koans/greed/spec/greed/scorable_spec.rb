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
    assert_equal 0, Greed::Scorable.new([]).score
  end

  def test_score_of_a_single_roll_of_5_is_50
    assert_equal 50, Greed::Scorable.new([5]).score
  end

  def test_score_of_a_single_roll_of_1_is_100
    assert_equal 100, Greed::Scorable.new([1]).score
  end

  def test_score_of_multiple_1s_and_5s_is_the_sum_of_individual_scores
    assert_equal 300, Greed::Scorable.new([1,5,5,1]).score
  end

  def test_score_of_single_2s_3s_4s_and_6s_are_zero
    assert_equal 0, Greed::Scorable.new([2,3,4,6]).score
  end

  def test_score_of_a_triple_1_is_1000
    assert_equal 1000, Greed::Scorable.new([1,1,1]).score
  end

  def test_score_of_other_triples_is_100x
    assert_equal 200, Greed::Scorable.new([2,2,2]).score
    assert_equal 300, Greed::Scorable.new([3,3,3]).score
    assert_equal 400, Greed::Scorable.new([4,4,4]).score
    assert_equal 500, Greed::Scorable.new([5,5,5]).score
    assert_equal 600, Greed::Scorable.new([6,6,6]).score
  end

  def test_score_of_mixed_is_sum
    assert_equal 250, Greed::Scorable.new([2,5,2,2,3]).score
    assert_equal 550, Greed::Scorable.new([5,5,5,5]).score
    assert_equal 1100, Greed::Scorable.new([1,1,1,1]).score
    assert_equal 1200, Greed::Scorable.new([1,1,1,1,1]).score
    assert_equal 1150, Greed::Scorable.new([1,1,1,5,1]).score
  end

  def test_non_scoring_of_mixed
    assert_equal [5, 3], Greed::Scorable.new([2,5,2,2,3]).non_scoring
    assert_equal [1, 5], Greed::Scorable.new([1,1,1,5,1]).non_scoring
    assert_equal [2, 3, 4, 6], Greed::Scorable.new([2,3,4,6]).non_scoring
    assert_equal [1, 5], Greed::Scorable.new([1,5,5,1]).non_scoring
  end

  def test_scoring_of_mixed
    assert_equal [2, 5], Greed::Scorable.new([2,5,2,2,3]).scoring
    assert_equal [1, 5], Greed::Scorable.new([1,1,1,5,1]).scoring
    assert_equal [], Greed::Scorable.new([2,3,4,6]).scoring
    assert_equal [1, 5], Greed::Scorable.new([1,5,5,1]).scoring
  end

end
