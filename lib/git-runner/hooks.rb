module GitRunner
  module Hooks
    extend self


    def registrations
      @registrations ||= Hash.new { |hash, key| hash[key] = [] }
    end

    def register(name, callable)
      unless callable.respond_to?(:call) && callable.respond_to?(:arity)
        raise InvalidCallable.new("Supplied callable is not callable, should respond to #call and #arity")
      end

      if callable.arity != 1
        raise InvalidCallable.new("Supplied callable takes #{callable.arity} argument(s), should accept only 1.")
      end

      registrations[name] << callable
    end

    def fire(name, data=nil)
      return unless registrations.keys.include?(name)
      registrations[name].each { |callable| callable.call(data) }
    end
  end
end


module GitRunner
  module Hooks
    class InvalidCallable < StandardError
    end
  end
end
