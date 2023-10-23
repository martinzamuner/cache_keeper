<h1 align="center">
  CacheKeeper
  <br>
</h1>

<h3 align="center">Keep cached methods always fresh in your Rails application.</h3>

<p align="center">
  <img alt="Build" src="https://img.shields.io/github/actions/workflow/status/martinzamuner/cache_keeper/ci.yml?branch=main">
  <img alt="Gem" src="https://img.shields.io/gem/v/cache_keeper">
  <img alt="rails version" src="https://img.shields.io/badge/rails-%3E%3D%206.1.0-informational">
  <img alt="License" src="https://img.shields.io/github/license/martinzamuner/cache_keeper">
</p>

CacheKeeper allows you to mark any method to be kept fresh in your Rails cache. It uses ActiveJob to refresh the cache in the background.


## Installation

Add CacheKeeper to your Gemfile:

```sh
bundle add cache_keeper
```


## Usage

CacheKeeper provides a `caches` method that will cache the result of the methods you give it:

```ruby
caches :slow_method, :really_slow_method, expires_in: 1.hour
caches :incredibly_slow_method, expires_in: 2.hours, must_revalidate: true
```

It is automatically available in your ActiveRecord models and in your controllers. You can also use it in any other class by including `CacheKeeper::Caching`.

By default, it will immediately run the method call if it hasn't been cached before. The next time it is called, it will return the cached value if it hasn't expired yet. If it has expired, it will enqueue a job to refresh the cache in the background and return the stale value in the meantime. You can avoid returning stale values by setting `must_revalidate: true` in the options.


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
end
```


## Development

<details>
  <summary>Running the tests</summary><br>

  - You can run the whole suite with `./bin/test test/**/*_test.rb`
</details>


## License

CacheKeeper is released under the [MIT License](https://opensource.org/licenses/MIT).
