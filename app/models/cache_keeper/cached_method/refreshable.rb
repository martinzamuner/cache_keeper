module CacheKeeper::CachedMethod::Refreshable
  def refresh(instance)
    Rails.cache.fetch(cache_key, expires_in: expires_in) do
      instance.send alias_for_original_method
    end
  end

  def refresh_later(instance)
    CacheKeeper::RefreshJob.perform_later self, instance
  end
end
