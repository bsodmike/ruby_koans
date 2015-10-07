module Greed

  class Player
    def initialize(name)
      @name = name
      @score = 0
    end

    attr_reader :name, :score

    def increment_score(score)
      @score += score
    end

    def decrement_score(score)
      decremented_score = @score - score
      @score = [decremented_score, 0].max # prevent a non-negative score.
    end
  end

end
