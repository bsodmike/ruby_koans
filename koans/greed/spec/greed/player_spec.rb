class Greed::PlayerSpec < Neo::Koan

  Player = Greed::Player

  def test_can_create_a_player
    assert_equal true, Player.new("Foo").instance_of?(::Greed::Player)
  end

  def test_can_get_players_name
    assert_equal "Foo", Player.new("Foo").name
  end
end
