Dir.glob(File.dirname(__FILE__) + "/greed/*", &method(:require))

# Playing Greed
#
# * Each player takes a turn consisting of one or more rolls of the dice.
#
# * After a player rolls and the score is calculated, the scoring dice are
#   removed and the player has the option of rolling again using only the
#   non-scoring dice.
#
# * If all of the thrown dice are scoring, then the player may roll all 5 dice
#   in the next roll.
#
# * If a roll has zero points, then the player loses not only their turn, but
#   also accumulated score for that turn.
#
module Greed

  class Game

    DICE_COUNT = 5
    FINAL_ROUND_LIMIT = 3000

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
      @round = 0
      @final_round = false
    end

    attr_reader :players

    # @param *names [Array<Object>] any number of names of players
    def self.start_game(*names)
      players = create_players(names)
      new(*players).run
    end

    def run
      while true do
        if @final_round
          puts "Now entering the final round..."

          play
          break
        end

        action = take_player_input

        result = take_action(action)
        break if result == :quit
      end

      puts "Thanks for playing!\n"
    end

    def play
      players.each_with_index do |player, index|

        turn_score = [1]
        dice = DICE_COUNT

        while turn_score.last > 0 do
          turn_score.pop if turn_score.size == 1 && turn_score[0] == 1

          puts "\nPlayer #{player.name}, rolling #{dice} dice..."

          result = take_turn(@round, dice, player, index)
          if result
            @turns << [index, result]
            turn_score << result[:score]
            dice = result[:remaining_dice]

            puts "Rolled #{result[:roll]} scoring #{result[:score]}!"

            process_score(@round, turn_score, player, result[:score]) unless zero_point_roll?(result[:roll], result[:score])
            if zero_point_roll?(result[:roll], result[:score])
              turn_total = turn_score.reduce(:+)
              player.decrement_score(turn_total)
            end

            @final_round = true if player.score >= FINAL_ROUND_LIMIT && !@final_round

            # NOTE: Ask player if they wish to proceed with another roll (given
            # they have remaining dice); if not, break.
            if dice > 0 && !zero_point_roll?(result[:roll], result[:score])
              print "You have #{dice} dice remaining, do you wish to roll (y/n)? "
              response = gets.chomp.downcase.to_sym

              break if response == :n
            end
          else
            break
          end
        end
      end

      @round += 1
      print_totals
    end

    def print_totals
      report = ""

      report << "\nPlayer\tTotal\n"
      report << "------\t-----\n"

      players.each { |player| report << "#{player.name}\t#{player.score}\n" }
      report << "\n"

      puts report
    end

    protected
    def print_commands
      commands = %(
# List of commands:
# -----------------
# play:   play another round
# quit:   exit game
)
      puts commands
    end

    def take_player_input
      print_commands

      print "Enter command: "
      gets.chomp.to_sym
    end

    def take_action(action)
      case action
      when :quit
        :quit
      when :play
        play
      else
        puts "\nYou seem confused, please check the commands list below"
      end
    end

    def take_turn(round, dice, player, index)
      set = DiceSet.new
      set.roll(dice)

      player_scoring = Scorable.new(set.values)
      remaining_dice = dice - player_scoring.scoring.size

      {
        round: round,
        score: player_scoring.score,
        roll: set.values,
        scoring_dice: player_scoring.scoring,
        non_scoring_dice: player_scoring.non_scoring,
        remaining_dice: remaining_dice
      }
    end

    def process_score(round, turn_scores, player, score)
      turn_total = turn_scores.reduce(:+)

      if player.score == 0 && turn_total >= 300
        player.increment_score(turn_total)
      elsif player.score >= 300
        player.increment_score(score)
      end
    end

    def zero_point_roll?(roll, score = 0)
      return true if roll.any? && score == 0

      false
    end

    # Used for debugging purposes only.
    #
    # @api private
    def show_totals
      report = ""

      report << "\nRound\tPlayer\tScore\tTotal\tRoll\n"
      report << "----\t------\t-----\t-----\t----\n"

      @turns.each do |turn|
        report << "#{turn[1][:round]}\t#{get_player(turn[0]).name}\t#{turn[1][:score]}\t#{get_player(turn[0]).score}\t#{turn[1][:roll]}\n"
      end
      report << "\n"

      report
    end

    def get_player(index)
      @players[index]
    end

    private
    def self.create_players(names)
      players = []
      names.each { |name| players << ::Greed::Player.new(name) }

      players
    end

  end

end

