require "test_helper"

class CacheKeeper::CachedMethod::RefreshableTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "#refresh_later enqueues a refresh job" do
    recording = Recording.create(number: 5)
    cached_method = CacheKeeper.manager.cached_methods.first

    assert_enqueued_with(job: CacheKeeper::RefreshJob) do
      cached_method.refresh_later recording
    end
  end
end
