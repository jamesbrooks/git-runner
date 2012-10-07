module GitRunner
  class Base
    attr_accessor :refs


    def initialize(refs=[])
      self.refs = refs
    end

    def run
      begin
        Text.begin

        if refs && refs.is_a?(Array)
          repository_path = Dir.pwd

          # Only process HEAD references
          refs.select { |str| str =~ /^refs\/heads\// }.each do |ref|
            branch_name = ref.split('/').last
            branch      = Branch.new(repository_path, branch_name)

            branch.run
          end
        end


      rescue GitRunner::Instruction::Failure => ex
        Text.new_line
        Text.out("Stopping runner, no further instructions will be performed\n")
        Text.new_line

      rescue GitRunner::Command::Failure => ex
        Text.new_line
        Text.out(Text.red("\u2716 Command failed: " + Text.red(ex.result.command)), :heading)

        write_error_log do |log|
          log << Command.history_to_s
        end

        Text.new_line

      rescue Exception => ex
        Text.new_line
        Text.out(Text.red("\u2716 Unknown exception occured: #{ex}"), :heading)

        write_error_log do |log|
          log << Command.history_to_s
          log << ex.message + "\n"
          log << ex.backtrace.map { |line| "    #{line}\n" }.join
        end

        Text.new_line

      ensure
        Text.finish
      end
    end


  private
    def write_error_log
      log_directory = File.join(Configuration.tmp_directory, 'logs')
      error_log     = File.join(log_directory, Time.now.strftime("%Y%m%d%H%M%S") + '-error.log')

      Command.execute("mkdir -p #{log_directory}") unless Dir.exists?(log_directory)

      File.open(error_log, 'w') { |file| yield(file) }

      Text.out("An error log has been created: #{error_log}")
      error_log
    end
  end
end
