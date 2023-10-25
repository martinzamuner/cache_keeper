require "test_helper"

class CacheKeeper::RefreshJobTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "uses the correct queue" do
    CacheKeeper.configuration.queues[:refresh] = "refresh"
    recording = Recording.create(number: 5)
    cached_method = CacheKeeper.manager.cached_methods.first

    assert_performed_with(queue: "refresh") do
      CacheKeeper::RefreshJob.perform_later cached_method, recording
    end
  end
end
