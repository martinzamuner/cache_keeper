module CacheKeeper
  class Manager
    attr_accessor :cached_methods

    def initialize
      self.cached_methods = CacheKeeper::Store.new
    end

    def handled?(klass, method_name)
      cached_methods.find_by(klass, method_name).present?
    end

    def handle(klass, method_name, options)
      CacheKeeper::CachedMethod.new(klass, method_name, options).tap do |cached_method|
        cached_methods << cached_method
      end
    end

    def activate_if_handling(klass, method_name)
      cached_method = cached_methods.find_by(klass, method_name) or return

      return unless requires_activation?(cached_method)

      CacheKeeper::ReplaceMethod.replace(cached_method) do
        cached_method.call(self)
      end
    end

    private

    def requires_activation?(cached_method)
      return false if cached_method.klass.instance_methods.exclude?(cached_method.method_name) && cached_method.klass.private_instance_methods.exclude?(cached_method.method_name)
      return false if cached_method.klass.private_instance_methods.include?(cached_method.alias_for_original_method)

      true
    end
  end
end
