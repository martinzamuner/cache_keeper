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

  test "#autorefresh enqueues a refresh job if it's stale" do
    with_clean_caching do
      recording = Recording.create(number: 5)
      cached_method = CacheKeeper.manager.cached_methods.first

      assert_enqueued_with(job: CacheKeeper::RefreshJob) do
        cached_method.autorefresh recording
      end
    end
  end

  test "#autorefresh doesn't enqueue a refresh job if it's fresh" do
    with_clean_caching do
      recording = Recording.create(number: 5)
      cached_method = CacheKeeper.manager.cached_methods.first
      cached_method.call(recording)

      assert_no_enqueued_jobs do
        cached_method.autorefresh recording
      end
    end
  end
end
