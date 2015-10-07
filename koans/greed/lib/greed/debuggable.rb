module Greed

  module Debuggable

    class << self
      def included klass
        klass.class_eval do
          include InstanceMethods
          private :show_totals
        end
      end
    end

    module InstanceMethods
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

        puts report
      end
    end

  end

end
