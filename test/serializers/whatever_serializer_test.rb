require "test_helper"

class CacheKeeper::WhateverSerializerTest < ActiveSupport::TestCase
  test "serializes whatever" do
    assert serializer.serialize?(RecordingsController.new)
  end

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
    CacheKeeper::WhateverSerializer
  end
end
