# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "~> 3.2"

gemspec

gem "async-io", github: "floriandejonckheere/async-io"

group :development do
  # Debugger
  gem "debug"

  # Task runner
  gem "rake"

  # Git hooks
  gem "overcommit"

  # Ruby static type checker
  gem "sorbet", "~> 0.5"
  gem "tapioca", require: false
end

group :test do
  # Change environment variables at runtime
  gem "climate_control"

  # Generic connection pool
  gem "connection_pool"

  # Object factories
  gem "factory_bot"

  # Random data generator
  gem "ffaker"

  # Redis client
  gem "redis"

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

  # Change time at runtime
  gem "timecop"
end
