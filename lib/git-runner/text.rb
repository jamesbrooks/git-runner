module GitRunner
  class Text
    COLOR_START = "\033["
    COLOR_END   = "m"
    COLOR_RESET = "#{COLOR_START}0#{COLOR_END}"

    COLORS = {
      :black  => 30,
      :red    => 31,
      :green  => 32,
      :yellow => 33,
      :blue   => 34,
      :purple => 35,
      :cyan   => 36,
      :white  => 37
    }

    STYLES = {
      :normal    => 0,
      :bold      => 1,
      :underline => 4
    }


    class << self
      def begin
        STDOUT.sync = true
        print("\e[1G       \e[1G")
      end

      def finish
        print("\n")
      end

      def out(str, style=nil)
        # Ensure that new lines overwrite the default 'remote: ' text
        str = str.gsub("\n", "\n\e[1G#{padding(nil)}")

        print "\n\e[1G#{padding(style).ljust(7)}#{str}"
      end

      def new_line
        out('')
      end

      # Color methods
      COLORS.each do |color, code|
        class_eval <<-EOF
          def #{color}(str, style=:normal)
            "#{COLOR_START}\#{STYLES[style]};#{code}#{COLOR_END}\#{str}#{COLOR_RESET}"
          end
        EOF
      end


    private
      def padding(style)
        case style
        when :heading
          '----->'
        else
          ''
        end
      end
    end
  end
end
