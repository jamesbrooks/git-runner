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

          if opts[:fail]
            raise Failure.new(self)
          end
        end
      end

      def should_run?
        true
      end

      def fail!
        raise Failure.new(self)
      end


    private
      def execute(*commands)
        Command.execute(*commands)
      end
    end
  end
end
