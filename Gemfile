# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in activerecord-dbt.gemspec.
gemspec

gem 'rails'

gem 'puma'

if RUBY_VERSION >= '3.3'
  gem 'sqlite3', '~> 2.1'
else
  gem 'sqlite3', '~> 1.4'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

# Start debugger with binding.b [https://github.com/ruby/debug]
# gem "debug", ">= 1.0.0"
