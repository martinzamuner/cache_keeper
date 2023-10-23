class CacheKeeper::RefreshAllJob < CacheKeeper::BaseJob
  queue_as { CacheKeeper.configuration.queues[:refresh] }

  def perform
    CacheKeeper.manager.cached_methods.autorefreshed.each do |cached_method|
      next unless cached_method.stale?

      cached_method.refresh_later
    end
  end
end
