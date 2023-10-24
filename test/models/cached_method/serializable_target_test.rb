require "test_helper"

class CacheKeeper::CachedMethod::SerializableTargetTest < ActiveSupport::TestCase
  test "#serialize_target doesn't allow unknown serializers" do
    recording = Recording.new(number: 5)
    cached_method = CacheKeeper::CachedMethod.new(Recording, :another_method, serializer: :unknown_serializer)

    error = assert_raises RuntimeError do
      cached_method.serialize_target(recording)
    end

    assert_includes error.message, "Unknown serializer: unknown_serializer"
  end

  test "#serialize_target raises an error if unable to serialize" do
    cached_method = CacheKeeper::CachedMethod.new(Recording, :another_method, serializer: :marshal)

    error = assert_raises RuntimeError do
      cached_method.serialize_target(Proc.new {})
    end

    assert_includes error.message, "Error serializing target using marshal:"
  end
end
