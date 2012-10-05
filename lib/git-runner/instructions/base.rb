module GitRunner
  class Instruction
    class Base
      attr_accessor :branch, :args, :opts


      def initialize(args)
        self.args = args
      end

      def perform
        # No-op
      end

      def run
        if should_run?
          perform
          Text.new_line

          if halt?
            raise InstructionHalted.new(self)
          end
        end
      end

      def should_run?
        true
      end

      def halt!
        self.opts ||= {}
        self.opts[:halt] = true
      end

      def halt?
        self.opts && !!self.opts[:halt]
      end

      def priority?
        self.opts && !!self.opts[:priority]
      end


    private
      def execute(*commands)
        Command.execute(*commands)
      end
    end
  end
end
