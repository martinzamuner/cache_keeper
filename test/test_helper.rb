ENV["RAILS_ENV"] = "test"

require_relative "./dummy/config/environment"

require "rails/test_help"
require "cache_helper"

class ActiveSupport::TestCase
  include CacheHelper
end
