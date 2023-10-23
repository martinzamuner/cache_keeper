class CacheKeeper::CachedMethod
  include Refreshable

  attr_accessor :klass, :method_name, :options

  def initialize(klass, method_name, options = {})
    self.klass = klass
    self.method_name = method_name
    self.options = options.with_indifferent_access
  end

  def alias_for_original_method
    :"__#{method_name}__hooked__"
  end

  def call(instance)
    if cache_entry.blank?
      refresh instance
    elsif cache_entry.expired?
      if must_revalidate?
        refresh instance
      else
        refresh_later instance

        cache_entry.value
      end
    else
      cache_entry.value
    end
  end

  private

  def cache_entry
    Rails.cache.send :read_entry, Rails.cache.send(:normalize_key, cache_key, {})
  end

  def cache_key
    ["CacheKeeper", klass, method_name]
  end

  def expires_in
    options[:expires_in]
  end

  def must_revalidate?
    options[:must_revalidate].nil? ? CacheKeeper.configuration.must_revalidate : options[:must_revalidate]
  end
end
