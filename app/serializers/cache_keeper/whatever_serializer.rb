class CacheKeeper::WhateverSerializer < ActiveJob::Serializers::ObjectSerializer
  def serialize?(argument)
    true
  end

  def serialize(whatever)
    super(
      "klass" => whatever.class.to_s
    )
  end

  def deserialize(hash)
    hash["klass"].constantize.new
  end
end
