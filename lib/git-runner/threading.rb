module GitRunner
  module Threading
    extend self


    def spawn
      raise ThreadError.new('must be called with a block') unless block_given?
      thread_group.add(Thread.new { yield })
    end

    def thread_group
      @thread_group ||= ThreadGroup.new
    end

    def join
      # TODO: Timeout with failure alerts

      thread_group.list.each(&:join)
    end
  end
end
