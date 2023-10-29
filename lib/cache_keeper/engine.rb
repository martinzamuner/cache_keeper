module CacheKeeper
  class Engine < ::Rails::Engine
    isolate_namespace CacheKeeper

    config.eager_load_namespaces << CacheKeeper

    config.cache_keeper = ActiveSupport::OrderedOptions.new
    config.cache_keeper.queues = ActiveSupport::OrderedOptions.new

    initializer "cache_keeper.active_job_serializer" do
      config.to_prepare do
        Rails.application.config.active_job.custom_serializers << CacheKeeper::CachedMethodSerializer
      end
    end

    initializer "cache_keeper.active_record_initializer" do
      ActiveSupport.on_load :active_record do
        include CacheKeeper::Caching
      end
    end
  end
end
