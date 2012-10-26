module GitRunner
  class Base
    attr_accessor :refs, :current_branch


    def initialize(refs=[])
      self.refs = refs
    end

    def run
      begin
        Text.begin

        load_git_runner_gems
        process_refs
        join_threads

      rescue GitRunner::Instruction::Failure => ex
        handle_instruction_failure_exception(ex)

      rescue GitRunner::Command::Failure => ex
        handle_command_failure_exception(ex)

      rescue Exception => ex
        handle_unknown_exception(ex)

      ensure
        Text.finish
      end
    end


  private
    def load_git_runner_gems
      # Load all additional gems that start with 'git-runner-'
      Gem::Specification._all.map(&:name).select { |gem| gem =~ /^git-runner-/ }.each { |name| require(name) }
    end

    def process_refs
      if refs && refs.is_a?(Array)
        repository_path = Dir.pwd

        # Only process HEAD references
        refs.select { |str| str =~ /^refs\/heads\// }.each do |ref|
          branch_name = ref.split('/').last

          self.current_branch = Branch.new(repository_path, branch_name)
          self.current_branch.run
        end
      end
    end

    def join_threads
      GitRunner::Threading.join
    end

    def handle_instruction_failure_exception(ex)
      Text.new_line
      Text.out("Stopping runner, no further instructions will be performed\n")
      Text.new_line
    end

    def handle_command_failure_exception(ex)
      Text.new_line
      Text.out(Text.red("\u2716 Command failed: " + Text.red(ex.result.command)), :heading)

      write_error_log do |log|
        log << Command.history_to_s
      end

      Text.new_line
    end

    def handle_unknown_exception(ex)
      Text.new_line
      Text.out(Text.red("\u2716 Unknown exception occured: #{ex}"), :heading)

      write_error_log do |log|
        log << Command.history_to_s
        log << ex.message + "\n"
        log << ex.backtrace.map { |line| "    #{line}\n" }.join
      end

      Text.new_line
    end

    def write_error_log
      log_directory = File.join(Configuration.tmp_directory, 'logs')
      error_log     = File.join(log_directory, Time.now.strftime("%Y%m%d%H%M%S") + '-error.log')

      Command.execute("mkdir -p #{log_directory}") unless Dir.exists?(log_directory)

      File.open(error_log, 'w') { |file| yield(file) }

      GitRunner::Hooks.fire(:after_write_error_log, {
        base:     self,
        log_file: error_log
      })

      Text.out("An error log has been created: #{error_log}")
      error_log
    end
  end
end
