class CacheKeeper::RefreshJob < CacheKeeper::BaseJob
  queue_as { CacheKeeper.configuration.queues[:refresh] }

  def perform(cached_method, target)
    cached_method.refresh target
  end
end
