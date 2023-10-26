class CacheKeeper::CachedMethod
  include Refreshable
  include SerializableTarget

  attr_accessor :klass, :method_name, :options

  def initialize(klass, method_name, options = {})
    self.klass = klass
    self.method_name = method_name
    self.options = options.with_indifferent_access
  end

  def alias_for_original_method
    :"__#{method_name}__hooked__"
  end

  def call(target)
    cache_entry = cache_entry(target)

    if cache_entry.blank?
      refresh target
    elsif cache_entry.expired?
      if must_revalidate?
        refresh target
      else
        refresh_later target

        cache_entry.value
      end
    else
      cache_entry.value
    end
  end

  private

  def cache_entry(target)
    Rails.cache.send :read_entry, Rails.cache.send(:normalize_key, cache_key(target), {})
  end

  def cache_key(target)
    if options[:key].is_a?(Proc)
      if options[:key].arity == 1
        target.instance_exec(method_name, &options[:key])
      else
        target.instance_exec(&options[:key])
      end
    elsif options[:key].present?
      options[:key]
    else
      target.respond_to?(:cache_key) ? ["CacheKeeper", target, method_name] : ["CacheKeeper", klass, method_name]
    end
  end

  def expires_in
    options[:expires_in]
  end

  def must_revalidate?
    options[:must_revalidate].nil? ? CacheKeeper.configuration.must_revalidate : options[:must_revalidate]
  end
end
