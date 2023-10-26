class CacheKeeper::MarshalSerializer < ActiveJob::Serializers::ObjectSerializer
  def serialize(target)
    super("dump" => Base64.encode64(Marshal.dump(target)))
  end

  def deserialize(json)
    Marshal.load Base64.decode64(json["dump"])
  end
end
