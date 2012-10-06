module GitRunner
  module Configuration
    extend self

    FILE_LOCATIONS = %w(/etc/git-runner.yml ~/.git-runner.yml)

    DEFAULTS = {
      'git_executable'     => '/usr/bin/env git',
      'instruction_file'   => 'config/deploy.rb',
      'instruction_prefix' => '# GitRunner:',
      'tmp_directory'      => '/tmp/git-runner',
    }


    def __attributes
      @attributes ||= __load_attributes
    end

    def method_missing(method, *args, &block)
      method_s = method.to_s

      if __attributes.keys.include?(method_s)
        __attributes[method_s]
      elsif method.to_s.end_with?('=')
        __attributes[method_s[0..-2]] = args[0]
      else
        super
      end
    end


  private
    def __load_attributes
      attrs = DEFAULTS.dup

      FILE_LOCATIONS.each do |location|
        begin
          path = File.expand_path(location)
          attrs.merge!(YAML.load_file(path)) if File.exist?(path)
        end
      end

      attrs
    end
  end
end
