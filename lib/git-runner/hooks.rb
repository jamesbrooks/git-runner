module GitRunner
  module Hooks
    extend self


    def registrations
      @registrations ||= Hash.new { |hash, key| hash[key] = [] }
    end

    def register(name, object, method)
      registrations[name] << [ object, method ]
    end

    def fire(name)
      return unless registrations.keys.include?(name)
      registrations[name].each { |object, method| object.send(method) }
    end
  end
end
