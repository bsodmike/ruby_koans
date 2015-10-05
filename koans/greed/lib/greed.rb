require File.expand_path(File.dirname(__FILE__) + '/greed/dice_set')
require File.expand_path(File.dirname(__FILE__) + '/greed/scorable')

module Greed

  class Game

    def self.simulate_turn
      set = DiceSet.new
      set.roll(5)
      puts set.values.inspect
      Scorable.new(set.values).score
    end
  end

  class Player

  end
end

