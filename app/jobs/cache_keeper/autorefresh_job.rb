class CacheKeeper::AutorefreshJob < CacheKeeper::BaseJob
  queue_as { CacheKeeper.configuration.queues[:refresh] }

  def perform
    CacheKeeper.manager.cached_methods.autorefreshed.each do |cached_method|
      cached_method.autorefresh_block.call
    end
  end
end
