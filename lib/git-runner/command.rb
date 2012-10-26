require 'session'

module GitRunner
  module Command
    extend self


    def execute(*commands)
      # Extract options (if any)
      opts = commands.last.is_a?(Hash) ? commands.pop : {}

      # Set session callback procs
      session.outproc = opts[:outproc]
      session.errproc = opts[:errproc]

      # Cycle through and run commands
      execute_commands(commands)

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
    def execute_commands(commands)
      commands.each do |command|
        begin
          out = StringIO::new

          # Run the command through the active shell session
          session.execute(command, :stdout => out, :stderr => out)

          # Construct result and store is as part of the command history
          result = Result.new(command, out.string, session.exit_status)
          history << result

          # Bubble up a failure exception if the command failed
          raise Failure.new(result) if result.failure?


        rescue Exception => ex
          unless ex.is_a?(GitRunner::Command::Failure)
            history << (result = Result.new(command, 'EXCEPTION OCCURRED', '-1'))
          end

          raise ex
        end
      end
    end

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
