require "cache_keeper/engine"

module CacheKeeper
  extend ActiveSupport::Autoload

  autoload :Caching
  autoload :Configuration
  autoload :Manager
  autoload :ReplaceMethod
  autoload :Store
  autoload :Cron

  mattr_accessor :logger, default: ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new($stdout))

  mattr_accessor :configuration, default: CacheKeeper::Configuration.new
  mattr_accessor :manager, default: CacheKeeper::Manager.new
end
