module CacheKeeper
  class Configuration
    DEFAULT_MUST_REVALIDATE = false
    DEFAULT_QUEUES = {}

    def must_revalidate
      return rails_config.must_revalidate unless rails_config.must_revalidate.nil?

      DEFAULT_MUST_REVALIDATE
    end

    def queues
      rails_config.queues || DEFAULT_QUEUES
    end

    private

    def rails_config
      Rails.application.config.cache_keeper
    end
  end
end
