require 'session'

module GitRunner
  module Command
    extend self


    def execute(*commands)
      opts = commands.last.is_a?(Hash) ? commands.pop : {}

      # Set session callback procs
      session.outproc = opts[:outproc]
      session.errproc = opts[:errproc]

      # Cycle through and run commands
      commands.each do |command|
        out = StringIO::new

        session.execute command, :stdout => out, :stderr => out

        result = Result.new(command, out.string, session.exit_status)
        history << result

        raise Failure.new(result) if result.failure?
      end

      # Clear session callback procs
      session.outproc = nil
      session.errproc = nil

      # Return full output of the last ran command (should this be all commands perhaps?)
      history.last.out
    end

    def history
      @history ||= []
    end

    def history_to_s
      history.map(&:to_s).join("\n#{'-' * 20}\n")
    end


  private
    def session
      @session ||= Session::Bash::Login.new
    end
  end
end

module GitRunner
  module Command
    class Result
      attr_accessor :command, :out, :status


      def initialize(command, out, status)
        self.command = command
        self.out     = out
        self.status  = status
      end

      def success?
        status == 0
      end

      def failure?
        !success?
      end

      def to_s
        "Status: #{status}; Command: #{command}\n#{out}"
      end
    end


    class Failure < StandardError
      attr_accessor :result


      def initialize(result)
        super(result.command)
        self.result = result
      end
    end
  end
end
