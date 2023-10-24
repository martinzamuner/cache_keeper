class CacheKeeper::MarshalSerializer < ActiveJob::Serializers::ObjectSerializer
  def serialize(target)
    super("dump" => Marshal.dump(target).force_encoding("ISO-8859-1").encode("UTF-8"))
  end

  def deserialize(json)
    Marshal.load(json["dump"].encode("ISO-8859-1").force_encoding("ASCII-8BIT"))
  end
end
