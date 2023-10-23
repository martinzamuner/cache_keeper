module CacheKeeper
  module Caching
    extend ActiveSupport::Concern

    included do
      def self.caches(*method_names, **options)
        method_names.each do |method_name|
          CacheKeeper.manager.handle self, method_name, options

          # If the method is already defined, we need to hook it
          method_added method_name
        end
      end

      def self.method_added(method_name)
        super

        CacheKeeper.manager.activate_if_handling self, method_name
      end
    end
  end
end
