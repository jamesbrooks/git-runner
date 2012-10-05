module GitRunner
  module Configuration
    extend self

    def __attributes
      # TODO: Load configuration from /etc/git-runner.conf
      @attributes ||= DEFAULT_CONFIGURATION.dup
    end

    def method_missing(method, *args, &block)
      if __attributes.keys.include?(method)
        __attributes[method]
      elsif method.to_s.end_with?('=')
        __attributes[method.to_s[0..-2].to_sym] = args[0]
      else
        super
      end
    end
  end
end
