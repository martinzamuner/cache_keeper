require "test_helper"

class CacheKeeper::EngineTest < ActiveSupport::TestCase
  test "registers the ActiveJob serializer for CachedMethod" do
    assert_includes Rails.application.config.active_job.custom_serializers, CacheKeeper::CachedMethodSerializer
  end

  test "doesn't register the ActiveJob serializer for whatever" do
    assert_not_includes Rails.application.config.active_job.custom_serializers, CacheKeeper::WhateverSerializer
  end
end
