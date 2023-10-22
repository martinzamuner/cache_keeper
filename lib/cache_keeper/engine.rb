class CacheKeeper::Engine < ::Rails::Engine
  isolate_namespace CacheKeeper

  config.cache_keeper = ActiveSupport::OrderedOptions.new

  initializer "cache_keeper.rails_config" do
    config.after_initialize do
      rails_config = Rails.application.config.cache_keeper

      CacheKeeper.logger = rails_config[:logger] if rails_config.key?(:logger)
      CacheKeeper.queues = rails_config[:queues] if rails_config.key?(:queues)
    end
  end

  initializer :cache_keeper do |app|
    ActiveSupport.on_load :action_controller do
      ActionController::Base.send :include, CacheKeeper::CachingMethods
    end

    ActiveSupport.on_load :active_record do
      include CacheKeeper::CachingMethods
    end
  end
end
