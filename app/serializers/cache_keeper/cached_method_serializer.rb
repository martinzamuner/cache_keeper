class CacheKeeper::CachedMethodSerializer < ActiveJob::Serializers::ObjectSerializer
  def serialize?(argument)
    argument.is_a? CacheKeeper::CachedMethod
  end

  def serialize(cached_method)
    super(
      "klass" => cached_method.klass,
      "method_name" => cached_method.method_name,
      "options" => cached_method.options
    )
  end

  def deserialize(hash)
    CacheKeeper::CachedMethod.new hash["klass"], hash["method_name"], hash["options"]
  end
end
