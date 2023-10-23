module CacheKeeper
  class Engine < ::Rails::Engine
    isolate_namespace CacheKeeper

    config.cache_keeper = ActiveSupport::OrderedOptions.new
    config.cache_keeper.queues = ActiveSupport::OrderedOptions.new
    config.cache_keeper.cron = ActiveSupport::OrderedOptions.new

    config.eager_load_namespaces << CacheKeeper
    config.autoload_once_paths = %W(
      #{root}/app/jobs
      #{root}/app/models
      #{root}/app/serializers
    )

    initializer "cache_keeper.active_job_serializer" do |app|
      config.to_prepare do
        Rails.application.config.active_job.custom_serializers << CacheKeeper::CachedMethodSerializer
      end
    end

    initializer "cache_keeper.cron_adapter" do |app|
      config.to_prepare do
        CacheKeeper.configuration.cron_adapter&.setup
      end
    end

    initializer "cache_keeper.caching_methods" do |app|
      ActiveSupport.on_load :action_controller do
        ActionController::Base.send :include, CacheKeeper::Caching
      end

      ActiveSupport.on_load :active_record do
        include CacheKeeper::Caching
      end
    end
  end
end
