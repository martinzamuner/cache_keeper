require_relative "lib/cache_keeper/version"

Gem::Specification.new do |s|
  s.name     = "cache_keeper"
  s.version  = CacheKeeper::VERSION
  s.authors  = ["Martin Zamuner"]
  s.email    = "martinzamuner@gmail.com"
  s.summary  = "Have your cached methods refreshed asynchronously and automatically"
  s.homepage = "https://github.com/martinzamuner/cache_keeper"
  s.license  = "MIT"

  s.required_ruby_version = ">= 2.5.0"

  s.add_dependency "rails", ">= 6.1.0"

  s.files      = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
end
