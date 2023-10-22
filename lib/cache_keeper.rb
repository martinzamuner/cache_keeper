require "cache_keeper/engine"

require "cache_keeper/manager"
require "cache_keeper/caching_methods"
require "cache_keeper/replace_method"

module CacheKeeper
  mattr_accessor :logger, default: ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new($stdout))
  mattr_accessor :queues, default: {}
  mattr_accessor :manager, default: CacheKeeper::Manager.new
end
