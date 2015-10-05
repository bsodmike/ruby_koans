module Greed

  class DiceSet
    def initialize
      @set = []
    end

    def roll(value)
      @set = []
      value.times do |i|
        attempt = *(1..6)
        @set << rand_sample_of(attempt)
      end
    end

    def values
      @set
    end

    private
    def rand_sample_of(set)
      return set.choice if RUBY_VERSION.to_s =~ /1\.8/

      set.sample
    end
  end

end
