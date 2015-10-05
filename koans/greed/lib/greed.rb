require File.expand_path(File.dirname(__FILE__) + '/greed/dice_set')
require File.expand_path(File.dirname(__FILE__) + '/greed/scorable')

module Greed

  class Game

    DICE_COUNT = 5

    def initialize(*players)
      @players = players
      @turns = []
    end

    attr_reader :players

    def run

      players.each_with_index do |player, index|
        puts "Turn for player #{player}"

        turn = 0
        turn_score = 1
        dice = DICE_COUNT

        while turn_score > 0 do
          # FIXME: Ask player to approve roll (auto-picking maximum available
          # dice).

          result = turn(turn, dice, player, index)
          if result
            @turns << [index, result]
            turn_score = result[:score]
            turn =+ 1
            dice = result[:remaining_dice]

            # FIXME: Ask player if they wish to proceed with another roll (given
            # they have remaining dice); if not, break.
          else
            break
          end
        end
      end
    end

    def turn_totals
      show_totals
    end

    protected
    def turn(count, dice, player, index)
      set = DiceSet.new
      set.roll(dice)

      player_scoring = Scorable.new(set.values)
      remaining_dice = dice - player_scoring.non_scoring.size

      if player_scoring.score > 0
        return {
          turn: count,
          score: player_scoring.score,
          roll: set.values,
          non_scoring_dice: player_scoring.non_scoring.size,
          remaining_dice: remaining_dice
        }
      end

      false
    end

    def show_totals
      report = ""

      report << "\nTurn\tPlayer\tScore\n"
      report << "----\t------\t-----\n"

      @turns.each do |turn|
        report << "#{turn[1][:turn]}\t#{@players[turn[0]]}\t#{turn[1][:score]}\n"
      end
      report << "\n"

      report
    end

  end

  class Player
    def initialize(name)
      @name = name
    end

    attr_reader :name
  end
end

