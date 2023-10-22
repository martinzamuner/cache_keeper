class CacheKeeper::Manager
  attr_accessor :cached_methods

  def initialize
    self.cached_methods = []
  end

  def find(klass, method_name)
    cached_methods.find do |cached_method|
      cached_method.klass == klass && cached_method.method_name == method_name
    end
  end

  def handled?(klass, method_name)
    find(klass, method_name).present?
  end

  def handle(klass, method_name, options)
    CacheKeeper::CachedMethod.new(klass, method_name, options).tap do |cached_method|
      cached_methods << cached_method
    end
  end

  def activate_if_handling(klass, method_name)
    cached_method = find(klass, method_name) or return

    return unless requires_activation?(cached_method)

    CacheKeeper::ReplaceMethod.replace(cached_method) do |*args|
      cached_method.call(self, *args)
    end
  end

  private

  def requires_activation?(cached_method)
    return false if cached_method.klass.instance_methods.exclude?(cached_method.method_name) && cached_method.klass.private_instance_methods.exclude?(cached_method.method_name)
    return false if cached_method.klass.private_instance_methods.include?(cached_method.alias_for_original_method)

    true
  end
end
