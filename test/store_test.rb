require "test_helper"

class CacheKeeper::StoreTest < ActiveSupport::TestCase
  test "#find_by returns only the one with the requested parameters" do
    cached_method = CacheKeeper::CachedMethod.new(String, :slow_method, {})
    autorefreshed_cached_method = CacheKeeper::CachedMethod.new(String, :really_slow_method, { autorefresh: true })
    store = CacheKeeper::Store.new([cached_method, autorefreshed_cached_method])

    assert_equal autorefreshed_cached_method, store.find_by(String, :really_slow_method)
  end
end
