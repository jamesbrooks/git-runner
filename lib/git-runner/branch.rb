module GitRunner
  class Branch
    attr_accessor :repository_path, :name


    def initialize(repository_path, name)
      self.repository_path = repository_path
      self.name            = name
    end

    def run
      instructions.each do |instruction|
        instruction.run
      end
    end

    def instructions
      @instructions ||= extract_instructions
    end

    def repository_name
      repository_path.split(File::SEPARATOR).last.gsub('.git', '')
    end

  private
    def extract_instructions
      # Use git to grep the current branch for instruction lines within the specific instruction file
      output = Command.execute(
        "cd #{repository_path}",
        "git grep '^#{Configuration.instruction_prefix}' #{name}:#{Configuration.instruction_file} || true"
      )

      # Process the output to generate instructions
      output.split("\n").map do |line|
        begin
          Instruction.from_raw(line).tap do |instruction|
            instruction.branch = self
          end

        rescue
        end
      end
    end
  end
end
