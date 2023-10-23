module CacheKeeper
  class Store < Array
    def find_by(klass, method_name)
      find do |cached_method|
        cached_method.klass == klass && cached_method.method_name == method_name
      end
    end

    def autorefreshed
      select do |cached_method|
        cached_method.options[:autorefresh].present?
      end
    end
  end
end
