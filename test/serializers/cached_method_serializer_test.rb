require "test_helper"

class CacheKeeper::CachedMethodSerializerTest < ActiveSupport::TestCase
  test "serializes only instances of CacheMethod" do
    recording = Recording.new(number: 5)
    cached_method = CacheKeeper::CachedMethod.new(Recording, :another_method, expires_in: 1.hour)

    assert serializer.serialize?(cached_method)
    assert_not serializer.serialize?(recording)
  end

  test "serializes the klass, method_name and options" do
    cached_method = CacheKeeper::CachedMethod.new(Recording, :another_method, expires_in: 1.hour)
    serialized = serializer.serialize(cached_method)

    assert_equal cached_method.klass, serialized["klass"]
    assert_equal cached_method.method_name, serialized["method_name"]
    assert_equal cached_method.options, serialized["options"]
  end

  test "deserializes the klass, method_name and options" do
    cached_method = CacheKeeper::CachedMethod.new(Recording, :another_method, expires_in: 1.hour)
    serialized = serializer.serialize(cached_method)
    deserialized = serializer.deserialize(serialized)

    assert_equal cached_method.klass, deserialized.klass
    assert_equal cached_method.method_name, deserialized.method_name
    assert_equal cached_method.options, deserialized.options
  end

  private

  def serializer
    CacheKeeper::CachedMethodSerializer
  end
end
