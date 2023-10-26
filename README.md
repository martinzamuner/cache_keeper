<h1 align="center">
  CacheKeeper
  <br>
</h1>

<h3 align="center">Have your cached methods refreshed asynchronously and automatically.</h3>

<p align="center">
  <img alt="Build" src="https://img.shields.io/github/actions/workflow/status/martinzamuner/cache_keeper/ci.yml?branch=main">
  <img alt="Gem" src="https://img.shields.io/gem/v/cache_keeper">
  <img alt="rails version" src="https://img.shields.io/badge/rails-%3E%3D%206.1.0-informational">
  <img alt="License" src="https://img.shields.io/github/license/martinzamuner/cache_keeper">
</p>

CacheKeeper is a Rails gem that allows you to mark any method to be kept fresh in your cache. It uses ActiveJob to refresh the cache in the background, either on demand or periodically.


## Installation

Add CacheKeeper to your Gemfile:

```sh
bundle add cache_keeper
```


## Usage

CacheKeeper provides a `caches` method that will cache the result of the methods you give it:

```ruby
class AlienAnecdoteAmplifier < ApplicationRecord
  caches :amplify, :enhance_hilarity, expires_in: 1.hour
  caches :generate_anecdotal_tales, expires_in: 2.hours, must_revalidate: true

  def amplify
    ...
  end

  def enhance_hilarity
    ...
  end

  def generate_anecdotal_tales
    ...
  end
end
```

It's automatically available in your ActiveRecord models and in your controllers. You can also use it in any other class by including `CacheKeeper::Caching`.

By default, it will immediately run the method call if it hasn't been cached before. The next time it is called, it will return the cached value if it hasn't expired yet. If it has expired, it will enqueue a job to refresh the cache in the background and return the stale value in the meantime. You can avoid returning stale values by setting `must_revalidate: true` in the options.

It's important to note that it will only work with methods that don't take any arguments.

### Cache key

CacheKeeper will compose cache keys from the name of the method and the instance's `cache_key` if it's defined or the name of the class otherwise. You can pass a `key` option to customize the cache key if you need it. It accepts [the same values](https://guides.rubyonrails.org/caching_with_rails.html#cache-keys) as `Rails.cache.fetch`, as well as procs or lambdas in case you need access to the instance:

```ruby
class NebulaNoodleTwister
  include CacheKeeper::Caching

  caches :twist_noodles, :dish_of_the_day, key: ->(method_name) { [:recoding, id, method_name] }
  caches :synchronize_taste_buds, key: -> { [:recoding, id, :synchronize_taste_buds] }
  caches :space_soup_simulation, key: :space_soup_simulation
end
```

### Serialization

CacheKeeper needs to pass the instance on which the cached method is called along to the refresh job. As any other job argument, ActiveJob requires it to be serializable. ActiveRecord instances are serializable by default, but controllers, POROs and other classes are not. CacheKeeper provides a `serializer` option that will work in most cases:

```ruby
class QuantumQuackerator
  include CacheKeeper::Caching

  # Generate a new instance using an empty initializer (QuantumQuackerator.new)
  # Useful for controllers and for POROs with no arguments
  caches :quackify_particles, serializer: :new_instance

  # Replicate the old instance using Marshal.dump and Marshal.load
  # Useful in most other cases, but make sure the dump is not too big
  caches :quackify_particles, serializer: :marshal
end
```

If those options don't work for you, you can always [write custom serializers](https://guides.rubyonrails.org/active_job_basics.html#serializers) for your classes.

### Autorefresh

CacheKeeper can automatically refresh your cached methods so that they are always warm. You need to pass a block to the `caches` method that will be called periodically. It will receive a `cached_method` object that you can use to `autorefresh` the cache for a specific instance:

```ruby
class LaughInducingLuminator < ApplicationRecord
  caches :generate_chuckles, expires_in: 1.day do |cached_method|
    find_each do { |luminator| cached_method.autorefresh luminator }
  end
end
```

The last step is to register the `CacheKeeper::AutorefreshJob` in whatever system you use to run jobs periodically. For example, if you use [GoodJob](https://github.com/bensheldon/good_job) you would do something like this:

```ruby
Rails.application.configure do
  config.good_job.enable_cron = true
  config.good_job.cron = {
    cache_keeper: {
      cron: "*/15 * * * *", # every 15 minutes, every day
      class: "CacheKeeper::AutorefreshJob"
    }
  }
end
```


## Configuration

CacheKeeper can be configured in an initializer, in any environment file or in your `config/application.rb` file. The following options are available:

```ruby
Rails.application.configure do
  # If a stale entry is requested, refresh immediately instead of enqueuing a refresh job.
  # Default: false
  config.cache_keeper.must_revalidate = true

  # The queue to use for the refresh jobs.
  # Default: nil (uses the default queue)
  config.cache_keeper.queues.refresh = :low_priority

  # The parent class of the refresh jobs.
  # Default: "ActiveJob::Base"
  config.cache_keeper.active_job_parent_class = "ApplicationJob"
end
```


## Development

<details>
  <summary>Running the tests</summary><br>

  - You can run the whole suite with `./bin/test test/**/*_test.rb`
</details>


## License

CacheKeeper is released under the [MIT License](https://opensource.org/licenses/MIT).
