Dir[File.join(File.dirname(__FILE__), 'instructions', '*.rb')].each { |file| require file }

module GitRunner
  class Instruction
    class InstructionHalted < StandardError ; end


    def self.new(name, args={})
      begin
        const_get(name).new(args)

      rescue NameError => e
        # Return a console message instruction to inform the user
        instruction      = ConsoleMessage.new(Text.red("\u2716 Instruction not found: #{name}"))
        instruction.opts = {
          :halt     => true,
          :priority => true
        }

        instruction
      end
    end

    def self.from_raw(raw)
      new(*%r[#{Regexp.escape(Configuration.instruction_prefix)}\s*(\w+)\s*(.*)$].match(raw).captures)
    end
  end
end
