require "test_helper"

class CacheKeeper::ManagerTest < ActiveSupport::TestCase
  test "keeps record of the cached methods" do
    assert_equal 1, CacheKeeper.manager.cached_methods.count
    assert_equal :slow_method, CacheKeeper.manager.cached_methods.first.method_name
  end
end
