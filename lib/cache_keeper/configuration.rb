module CacheKeeper
  class Configuration
    DEFAULT_MUST_REVALIDATE = false
    DEFAULT_QUEUES = {}.freeze
    DEFAULT_ACTIVE_JOB_PARENT_CLASS = "ActiveJob::Base".freeze

    def must_revalidate
      return rails_config.must_revalidate unless rails_config.must_revalidate.nil?

      DEFAULT_MUST_REVALIDATE
    end

    def queues
      rails_config.queues || DEFAULT_QUEUES
    end

    def active_job_parent_class
      rails_config.active_job_parent_class || DEFAULT_ACTIVE_JOB_PARENT_CLASS
    end

    private

    def rails_config
      Rails.application.config.cache_keeper
    end
  end
end
