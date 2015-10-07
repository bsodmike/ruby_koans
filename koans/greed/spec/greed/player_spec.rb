class Greed::PlayerSpec < Neo::Koan

  Player = Greed::Player

  def test_can_create_a_player
    assert_equal true, Player.new("Foo").instance_of?(::Greed::Player)
  end

  def test_can_get_players_name
    assert_equal "Foo", Player.new("Foo").name
  end

  SpecPlayer = Player.new("Mike")

  def test_can_get_player_score
    assert_equal 0, SpecPlayer.score
  end

  def test_can_increment_player_score
    assert_equal 200, SpecPlayer.increment_score(200)
    assert_equal 350, SpecPlayer.increment_score(150)
  end

  def test_can_also_decrement_player_score
    assert_equal 300, SpecPlayer.decrement_score(50)
    assert_equal 0, SpecPlayer.decrement_score(350) # Prevents a negative score
  end

end
