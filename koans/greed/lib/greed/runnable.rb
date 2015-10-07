module Greed

  module Runnable

    class << self
      def included klass
        klass.class_eval do
          include InstanceMethods
        end
      end
    end

    module InstanceMethods
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

      protected
      def print_commands
        commands = %(
  # List of commands:
  # -----------------
  # [p]lay:   play another round
  # [q]uit:   exit game
  )
        puts commands
      end

      def take_player_input
        print_commands

        print "Enter command: "
        STDIN.gets.chomp.to_sym
      end

      def take_action(action)
        case
        when action == :quit || action == :q
          :quit
        when action == :play || action == :p
          play
        else
          puts "\nYou seem confused, please check the commands list below"
        end
      end
    end

  end

end
