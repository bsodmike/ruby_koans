class Greed::GameSpec < Neo::Koan

  Player = Greed::Player

  def test_can_create_a_game
    subject = Greed::Game.new
    assert_equal true, subject.instance_of?(Greed::Game)
  end

  def test_creating_a_game_with_players
    players = [Player.new("Bob"), Player.new("Bill")]
    subject = Greed::Game.new(*players)
    assert_equal players, subject.instance_variable_get("@players")
  end

  def test_game_players_are_readable
    subject = Greed::Game.new(Player.new("Bob"))
    assert_equal true, subject.respond_to?(:players)
  end

end
