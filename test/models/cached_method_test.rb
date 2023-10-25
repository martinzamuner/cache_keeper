require "test_helper"

class CacheKeeper::CachedMethodTest < ActiveSupport::TestCase
  test "#call caches the result of the original method" do
    recording = Recording.create(number: 5)
    cached_method = manager.handle(Recording, :another_method, expires_in: 1.hour)
    manager.activate_if_handling(Recording, :another_method)

    result = cached_method.call(recording)

    assert_equal 5, result
    assert cache_has_key? "CacheKeeper/recordings/#{recording.id}/another_method"
  end

  private

  def manager
    @manager ||= CacheKeeper::Manager.new
  end
end
