require "test_helper"

class CacheKeeper::EngineTest < ActiveSupport::TestCase
  test "registers the ActiveJob serializer for CachedMethod" do
    assert_includes Rails.application.config.active_job.custom_serializers, CacheKeeper::CachedMethodSerializer
  end

  test "doesn't register the ActiveJob new_instance serializer" do
    assert_not_includes Rails.application.config.active_job.custom_serializers, CacheKeeper::NewInstanceSerializer
  end

  test "doesn't register the ActiveJob marshal serializer" do
    assert_not_includes Rails.application.config.active_job.custom_serializers, CacheKeeper::MarshalSerializer
  end
end
