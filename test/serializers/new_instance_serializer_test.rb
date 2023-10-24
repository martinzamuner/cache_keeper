require "test_helper"

class CacheKeeper::NewInstanceSerializerTest < ActiveSupport::TestCase
  test "serializes the class name" do
    serialized = serializer.serialize(RecordingsController.new)

    assert_equal serialized["klass"], "RecordingsController"
  end

  test "deserializes the class name" do
    serialized = serializer.serialize(RecordingsController.new)
    deserialized = serializer.deserialize(serialized)

    assert_equal RecordingsController, deserialized.class
  end

  private

  def serializer
    CacheKeeper::NewInstanceSerializer
  end
end
