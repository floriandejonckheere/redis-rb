# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.2"

gemspec

gem "async-io", github: "floriandejonckheere/async-io"

group :test, :development do
  # Generic connection pool
  gem "connection_pool"

  # Redis client
  gem "redis"
end

group :development do
  # Change environment variables at runtime
  gem "climate_control"

  # Debugger
  gem "debug"

  # Object factories
  gem "factory_bot"

  # Random data generator
  gem "ffaker"

  # Git hooks
  gem "overcommit"

  # Task runner
  gem "rake"

  # Behaviour-driven testing
  gem "rspec"

  # Ruby linter
  gem "rubocop"
  gem "rubocop-performance"
  gem "rubocop-rake"
  gem "rubocop-rspec"

  # RSpec matchers
  gem "shoulda-matchers"

  # Code coverage
  gem "simplecov"

  # Display rich diffs in RSpec
  gem "super_diff"

  # Ruby static type checker
  gem "sorbet", "~> 0.5"
  gem "tapioca", require: false

  # Change time at runtime
  gem "timecop"
end
