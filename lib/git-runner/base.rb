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


      rescue GitRunner::Instruction::InstructionHalted => ex
        Text.out("Stopping runner, no further instructions will be performed\n")

      rescue GitRunner::Command::Failure => ex
        Text.out("\n")
        Text.out(Text.red("\u2716 Command failed: " + Text.red(ex.result.command)), :heading)

        # Write error log
        log_directory = File.join(Configuration.tmp_directory, 'logs')
        error_log     = File.join(log_directory, Time.now.strftime("%Y%m%d%H%M%S") + '-error.log')

        Dir.mkdir(log_directory) unless Dir.exists?(log_directory)
        File.open(error_log, 'w') do |file|
          Command.history.each do |result|
            file << "Status: #{result.status}; Command: #{result.command}\n"
            file << result.out
            file << "\n--------------------\n"
          end
        end

        Text.out("An error log has been created: #{error_log}")
        Text.new_line

      rescue Exception => ex
        Text.new_line
        Text.out(Text.red("\u2716 Unknown exception occured: #{ex}"), :heading)
        Text.out(ex.backtrace.join("\n").gsub("\n", "\n#{''.ljust(10)}"))
        Text.new_line

      ensure
        Text.finish
      end
    end
  end
end
