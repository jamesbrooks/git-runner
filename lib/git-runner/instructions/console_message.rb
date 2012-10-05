module GitRunner
  class Instruction
    class ConsoleMessage < Base
      def perform
        Text.out(message, :heading)
      end

      def message
        args
      end
    end
  end
end
