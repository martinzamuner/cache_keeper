require "test_helper"

class CacheKeeper::MarshalSerializerTest < ActiveSupport::TestCase
  test "serializes the marshal dump" do
    target = Recording.new
    serialized = serializer.serialize(target)

    assert_equal serialized["dump"], Marshal.dump(target).force_encoding("ISO-8859-1").encode("UTF-8")
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
