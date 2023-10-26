require "test_helper"

class CacheKeeper::MarshalSerializerTest < ActiveSupport::TestCase
  test "serializes the marshal dump" do
    target = Recording.new
    serialized = serializer.serialize(target)

    assert_equal serialized["dump"], Base64.encode64(Marshal.dump(target))
  end

  test "deserializes the marshal dump" do
    target = Recording.new
    serialized = serializer.serialize(target)
    deserialized = serializer.deserialize(serialized)

    assert_equal Recording, deserialized.class
  end

  private

  def serializer
    CacheKeeper::MarshalSerializer
  end
end
