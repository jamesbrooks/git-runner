module GitRunner
  class Instruction
    class Base
      attr_accessor :branch, :args, :opts


      def initialize(args, opts={})
        self.args = args
        self.opts = opts
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
        self.opts[:halt] = true
      end

      def halt?
        !!self.opts[:halt]
      end

      def priority?
        !!self.opts[:priority]
      end


    private
      def execute(*commands)
        Command.execute(*commands)
      end
    end
  end
end
