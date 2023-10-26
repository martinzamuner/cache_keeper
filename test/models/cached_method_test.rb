require "test_helper"

class CacheKeeper::CachedMethodTest < ActiveSupport::TestCase
  test "#call caches the result of the original method" do
    with_clean_caching do
      recording = Recording.create(number: 5)
      cached_method = manager.handle(Recording, :another_method, expires_in: 1.hour)
      manager.activate_if_handling(Recording, :another_method)

      result = cached_method.call(recording)

      assert_equal 5, result
      assert cache_has_key? "CacheKeeper/recordings/#{recording.id}/another_method"
    end
  end

  test "#stale? is true for cold caches" do
    with_clean_caching do
      recording = Recording.create(number: 5)
      cached_method = manager.handle(Recording, :another_method, expires_in: 1.hour)

      assert cached_method.stale?(recording)
    end
  end

  test "#stale? is true for expired caches" do
    with_clean_caching do
      recording = Recording.create(number: 5)
      cached_method = manager.handle(Recording, :another_method, expires_in: 0.01.seconds)
      manager.activate_if_handling(Recording, :another_method)
      cached_method.call(recording)

      sleep 0.01

      assert cached_method.stale?(recording)
    end
  end

  test "#stale? is false for fresh caches" do
    with_clean_caching do
      recording = Recording.create(number: 5)
      cached_method = manager.handle(Recording, :another_method, expires_in: 1.hour)
      manager.activate_if_handling(Recording, :another_method)
      cached_method.call(recording)

      assert_not cached_method.stale?(recording)
    end
  end

  test ":key option accepts arrays" do
    cached_method = manager.handle(Recording, :another_method, key: ["QuantumQuackerator", "quackify_particles"])
    cache_key = cached_method.send :cache_key, Recording.new

    assert_equal ["QuantumQuackerator", "quackify_particles"], cache_key
  end

  test ":key option accepts procs with no arguments" do
    cached_method = manager.handle(Recording, :another_method, key: proc { 123 })
    cache_key = cached_method.send :cache_key, Recording.new

    assert_equal 123, cache_key
  end

  test ":key option accepts procs with an argument" do
    cached_method = manager.handle(Recording, :another_method, key: proc { |method_name| [method_name, 123] })
    cache_key = cached_method.send :cache_key, Recording.new

    assert_equal [:another_method, 123], cache_key
  end

  test ":key option accepts lambdas with no arguments" do
    cached_method = manager.handle(Recording, :another_method, key: -> { 123 })
    cache_key = cached_method.send :cache_key, Recording.new

    assert_equal 123, cache_key
  end

  test ":key option accepts lambdas with an argument" do
    cached_method = manager.handle(Recording, :another_method, key: ->(method_name) { [method_name, 123] })
    cache_key = cached_method.send :cache_key, Recording.new

    assert_equal [:another_method, 123], cache_key
  end

  private

  def manager
    @manager ||= CacheKeeper::Manager.new
  end
end
