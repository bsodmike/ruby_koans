class Greed::GameSpec < Neo::Koan

  def test_can_create_a_game
    subject = Greed::Game.new
    assert_equal true, subject.instance_of?(Greed::Game)
  end

  def test_creating_a_game_with_players
    subject = Greed::Game.new(:foo, :bar)
    assert_equal [:foo, :bar], subject.instance_variable_get("@players")
  end

end
