class CacheKeeper::RefreshJob < CacheKeeper::BaseJob
  queue_as { CacheKeeper.configuration.queues[:refresh] }

  def perform(cached_method, instance)
    cached_method.refresh instance
  end
end
