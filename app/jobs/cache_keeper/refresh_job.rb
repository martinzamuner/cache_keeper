class CacheKeeper::RefreshJob < ActiveJob::Base
  queue_as { CacheKeeper.queues[:refresh] }

  discard_on ActiveRecord::RecordNotFound

  def perform(cached_method)
    cached_method.refresh
  end
end
