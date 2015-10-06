require File.expand_path(File.dirname(__FILE__) + '/greed/dice_set')
require File.expand_path(File.dirname(__FILE__) + '/greed/scorable')

module Greed

  class Game

    DICE_COUNT = 5

    # Scoring is managed via the Game instance, by storing turn-by-turn details
    # within the `@turns` instance variable, with the following structure
    #
    #   [
    #     [index, details_hsh]
    #   ]
    #
    # As the game is initialised with an explicit list of players (and held
    # within an array), conveniently their index within this array (accessible
    # via `#players`) is held as the first array element; the second and final
    # element is a hash containing details of each play a players makes.
    #
    # @param *players [Array<Object>] any number of players for a game
    def initialize(*players)
      @players = players
      @turns = []
      @turn = 0
    end

    attr_reader :players

    # @param *names [Array<Object>] any number of names of players
    def self.start_game(*names)
      players = create_players(names)
      new(*players)
    end

    def play
      players.each_with_index do |player, index|
        puts "Turn for player #{player}"

        turn_score = 1
        dice = DICE_COUNT

        while turn_score > 0 do
          # FIXME: Ask player to approve roll (auto-picking maximum available
          # dice).

          result = take_turn(@turn, dice, player, index)
          if result
            @turns << [index, result]
            turn_score = result[:score]
            dice = result[:remaining_dice]

            # FIXME: Ask player if they wish to proceed with another roll (given
            # they have remaining dice); if not, break.
          else
            break
          end
        end
      end

      @turn += 1
    end

    def turn_totals
      show_totals
    end

    protected
    def take_turn(count, dice, player, index)
      set = DiceSet.new
      set.roll(dice)

      player_scoring = Scorable.new(set.values)
      remaining_dice = dice - player_scoring.non_scoring.size

      if player_scoring.score > 0
        return {
          turn: count,
          score: player_scoring.score,
          roll: set.values,
          non_scoring_dice: player_scoring.non_scoring,
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
        report << "#{turn[1][:turn]}\t#{get_player_name(turn[0])}\t#{turn[1][:score]}\n"
      end
      report << "\n"

      report
    end

    def get_player_name(index)
      @players[index].name
    end

    private
    def self.create_players(names)
      players = []
      names.each { |name| players << ::Greed::Player.new(name) }

      players
    end

  end

  class Player
    def initialize(name)
      @name = name
    end

    attr_reader :name
  end
end

