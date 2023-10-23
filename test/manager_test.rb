require "test_helper"

class CacheKeeper::ManagerTest < ActiveSupport::TestCase
  test "keeps record of the cached methods" do
    # Load model
    Recording

    assert_equal 1, CacheKeeper.manager.cached_methods.count
    assert_equal :slow_method, CacheKeeper.manager.cached_methods.first.method_name
  end

  test "doesn't allow to autorefresh ActiveRecord models" do
    manager = CacheKeeper::Manager.new

    assert_raises RuntimeError do
      manager.handle Recording, :slow_method, autorefresh: true
    end
  end

  test "doesn't allow to activate methods with parameters" do
    manager = CacheKeeper::Manager.new
    manager.handle Recording, :unsupported_method, {}

    assert_raises RuntimeError do
      manager.activate_if_handling Recording, :unsupported_method
    end
  end
end
