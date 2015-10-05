class Greed::GameSpec < Neo::Koan

  def test_can_create_a_game
    subject = Greed::Game.new
    assert_equal true, subject.instance_of?(Greed::Game)
  end

  def test_creating_a_game_with_players
    subject = Greed::Game.new(:foo, :bar)
    assert_equal [:foo, :bar], subject.instance_variable_get("@players")
  end

  def test_game_players_are_readable
    assert_equal true, Greed::Game.new(:foo).respond_to?(:players)
  end

end
