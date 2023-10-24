require "test_helper"

class CacheKeeper::RefreshJobTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "calls #refresh" do
    recording = Recording.create(number: 5)
    cached_method = CacheKeeper.manager.cached_methods.first

    assert_performed_with(queue: :default) do
      CacheKeeper::RefreshJob.perform_later cached_method, recording
    end
  end
end
