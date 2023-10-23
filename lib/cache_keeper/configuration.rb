module CacheKeeper
  class Configuration
    DEFAULT_MUST_REVALIDATE = false
    DEFAULT_QUEUES = {}
    DEFAULT_CRON_EXPRESSION = "*/15 * * * *" # Every 15 minutes, every day

    def must_revalidate
      return rails_config.must_revalidate unless rails_config.must_revalidate.nil?

      DEFAULT_MUST_REVALIDATE
    end

    def queues
      rails_config.queues || DEFAULT_QUEUES
    end

    def cron_adapter
      return if rails_config.cron.adapter.nil?

      case rails_config.cron.adapter
      when :good_job
        CacheKeeper::Cron::GoodJobAdapter
      else
        raise "Unknown cron adapter: #{rails_config.cron.adapter}"
      end
    end

    def cron_expression
      rails_config.cron.expression || DEFAULT_CRON_EXPRESSION
    end

    private

    def rails_config
      Rails.application.config.cache_keeper
    end
  end
end
