class CacheKeeper::Engine < ::Rails::Engine
  isolate_namespace CacheKeeper

  config.cache_keeper = ActiveSupport::OrderedOptions.new
  config.cache_keeper.queues = ActiveSupport::InheritableOptions.new

  initializer "cache_keeper.active_job_serializer" do |app|
    config.to_prepare do
      Rails.application.config.active_job.custom_serializers << CacheKeeper::CachedMethodSerializer
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
