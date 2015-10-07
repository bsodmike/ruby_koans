Dir.glob(File.dirname(__FILE__) + "/greed/*", &method(:require))

# Playing Greed
#
# Greed is a dice game played among 2 or more players, using 5 six-sided dice.
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
# * If a player decides to stop rolling before rolling a zero-point roll, then
#   the accumulated points for the turn is added to his total score.
#
# * Before a player is allowed to accumulate points, they must get at least 300
#   points in a single turn. Once they have achieved 300 points in a single
#   turn, the points earned in that turn and each following turn will be
#   counted toward their total score.
#
# * Once a player reaches 3000 (or more) points, the game enters the final
#   round where each of the other players gets one more turn. The winner is the
#   player with the highest score after the final round.
#
# Futher rules are detailed in `GREED_RULES.txt`.
module Greed

  class Game
    include Debuggable
    include Runnable

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

    def play
      players.each_with_index do |player, index|

        turn_score = [1]
        dice = DICE_COUNT

        while turn_score.last > 0 do
          turn_score.pop if turn_score.size == 1 && turn_score[0] == 1

          puts "\nPlayer #{player.name}, rolling #{dice} dice..."

          result = take_turn(@round, dice, player, index)
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
            response = STDIN.gets.chomp.downcase.to_sym

            break if response == :n
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

      ranked_players = players.sort { |x,y| y.score <=> x.score }
      ranked_players.each { |player| report << "#{player.name}\t#{player.score}\n" }
      report << "\n"

      puts report
    end

    protected
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

