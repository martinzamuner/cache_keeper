module CacheKeeper::CachedMethod::SerializableTarget
  def serialize_target?
    options[:serializer].present?
  end

  def serialize_target(target)
    case options[:serializer]
    when :new_instance
      CacheKeeper::NewInstanceSerializer.serialize target
    when :marshal
      CacheKeeper::MarshalSerializer.serialize target
    else
      raise "Unknown serializer: #{options[:serializer]}"
    end
  rescue StandardError => e
    raise "Error serializing target using #{options[:serializer]}: #{e}"
  end
end
