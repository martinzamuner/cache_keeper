class CacheKeeper::NewInstanceSerializer < ActiveJob::Serializers::ObjectSerializer
  def serialize(target)
    super("klass" => target.class.to_s)
  end

  def deserialize(json)
    json["klass"].constantize.new
  end
end
