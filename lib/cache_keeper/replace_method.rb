# Based on https://github.com/Shopify/sorbet/blob/master/gems/sorbet-runtime/lib/types/private/class_utils.rb
class CacheKeeper::ReplaceMethod
  class << self
    def replace(cached_method, &block)
      klass = cached_method.klass
      method_name = cached_method.method_name
      alias_for_original_method = cached_method.alias_for_original_method
      original_visibility = visibility_method_name(klass, method_name)

      define_method_with_visibility klass, method_name, alias_for_original_method, original_visibility, &block
    end

    private

    # `name` must be an instance method (for class methods, pass in mod.singleton_class)
    def visibility_method_name(klass, method_name)
      if klass.public_method_defined? method_name
        :public
      elsif klass.protected_method_defined? method_name
        :protected
      elsif klass.private_method_defined? method_name
        :private
      else
        raise NameError.new("undefined method `#{method_name}` for `#{klass}`")
      end
    end

    def define_method_with_visibility(klass, method_name, alias_for_original_method, visibility, &block)
      klass.module_exec do
        alias_method alias_for_original_method, method_name
        private alias_for_original_method

        # Start a visibility (public/protected/private) region, so that
        # all of the method redefinitions happen with the right visibility
        # from the beginning. This ensures that any other code that is
        # triggered by `method_added`, sees the redefined method with the
        # right visibility.
        send visibility

        define_method method_name, &block

        if block && block.arity < 0 && respond_to?(:ruby2_keywords, true)
          ruby2_keywords method_name
        end
      end
    end
  end
end
