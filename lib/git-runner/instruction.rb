require 'git-runner/instructions/base'
require 'git-runner/instructions/display'

module GitRunner
  class Instruction
    def self.new(name, args={})
      begin
        const_get(name).new(args)

      rescue NameError => e
        # Display message for missing instruction, halt further execution
        Display.new(Text.red("\u2716 Instruction not found: #{name}"), {
          :fail     => true,
          :priority => true
        })
      end
    end

    def self.from_raw(raw)
      new(*%r[#{Regexp.escape(Configuration.instruction_prefix)}\s*(\w+)\s*(.*)$].match(raw).captures)
    end
  end
end

module GitRunner
  class Instruction
    class Failure < StandardError
    end
  end
end
