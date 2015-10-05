module Greed

  class Scorable

    def initialize(dice)
      @dice = dice
      @non_scoring = []
    end

    attr_reader :dice

    def score
      @non_scoring = []
      tally = 0

      counts = Hash.new(0)
      dice.each { |x| counts[x] += 1 }

      (1..6).each do |i|
        if counts[i] >= 3
          i == 1 ? tally += 1000 : tally += 100 * i
          counts[i] = [counts[i] - 3, 0].max
        end

        if i == 1
          tally += 100 * counts[i]
        elsif i == 5
          tally += 50 * counts[i]
        end
      end

      @non_scoring << counts.select { |k, v| v > 0 }.keys

      tally
    end

    def non_scoring
      score if @non_scoring.empty?
      @non_scoring.flatten
    end

  end

end
