source "https://rubygems.org"

gemspec

rails_version = ENV.fetch("RAILS_VERSION", "7.1")

rails_constraint =
  if rails_version == "main"
    { github: "rails/rails" }
  else
    "~> #{rails_version}.0"
  end

gem "rails", rails_constraint
gem "sqlite3"

group :debug do
  gem "byebug"

  gem "rubocop"
  gem "rubocop-performance"
  gem "rubocop-rails"
end
