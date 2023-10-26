module CacheKeeper::CachedMethod::Refreshable
  def refresh(target)
    Rails.cache.fetch(cache_key(target), expires_in: expires_in) do
      target.send alias_for_original_method
    end
  end

  def refresh_later(target)
    CacheKeeper::RefreshJob.perform_later self, target
  end

  def autorefresh(target)
    return unless stale?(target)

    refresh_later target
  end
end
