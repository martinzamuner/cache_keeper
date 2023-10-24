module CacheKeeper
  class Cron::GoodJobAdapter
    def self.setup
      Rails.application.config.good_job.cron[:cache_keeper] = {
        class: "CacheKeeper::RefreshAllJob",
        cron: CacheKeeper.configuration.cron_expression
      }
    end
  end
end
