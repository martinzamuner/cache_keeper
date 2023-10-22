class CacheKeeper::CachedMethod
  attr_accessor :klass, :method_name, :options

  def initialize(klass, method_name, options)
    self.klass = klass
    self.method_name = method_name
    self.options = options
  end

  def alias_for_original_method
    :"__#{method_name}__hooked__"
  end

  def call(instance, *args)
    puts "cached: #{klass}##{method_name} #{options}"

    Rails.cache.fetch(["CacheKeeper", klass, method_name], expires_in: options[:expires_in]) do
      instance.send alias_for_original_method, *args
    end
  end
end
