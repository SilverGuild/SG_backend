source "https://rubygems.org"

# ------------------------------------------------------------------
# Core framework
# ------------------------------------------------------------------

# Full-stack web application framework.
# Pinned "~> 8.1.1" already permits >= 8.1.1, < 8.2 — which includes
# 8.1.3.1, the patched release for CVE-2026-66066 (Active Storage
# variant-processing RCE). Run `bundle update rails` to pull the
# patched version into Gemfile.lock, then re-run bundle-audit to confirm.
gem "rails", "~> 8.1.1"

# ------------------------------------------------------------------
# Database
# ------------------------------------------------------------------

gem "pg", "~> 1.6" # PostgreSQL adapter for Active Record

# ------------------------------------------------------------------
# Web server
# ------------------------------------------------------------------

gem "puma", ">= 5.0" # Application server

# ------------------------------------------------------------------
# API / serialization
# ------------------------------------------------------------------

gem "jsonapi-serializer" # JSON:API-style serialization for API responses

# ------------------------------------------------------------------
# Caching
# ------------------------------------------------------------------

gem "solid_cache" # Database-backed Rails.cache store

# ------------------------------------------------------------------
# Authentication
# ------------------------------------------------------------------

gem "bcrypt", "~> 3.1.7" # Password hashing for has_secure_password (backs Rails-side session auth)

# ------------------------------------------------------------------
# Authorization
# ------------------------------------------------------------------

gem "pundit" # Policy-based authorization (Character/User policies) — not yet wired up, planned

# ------------------------------------------------------------------
# External HTTP client
# ------------------------------------------------------------------

gem "faraday" # HTTP client used to proxy the live D&D 5e reference API

# ------------------------------------------------------------------
# Cross-origin requests
# ------------------------------------------------------------------

gem "rack-cors" # CORS handling — required since SG_frontend runs on a separate origin/port

# ------------------------------------------------------------------
# Boot / platform
# ------------------------------------------------------------------

gem "tzinfo-data", platforms: %i[ windows jruby ] # Timezone data for platforms without system zoneinfo
gem "bootsnap", require: false                    # Caches to reduce boot time

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude" # Ruby's built-in interactive debugger
  gem "rubocop-rails-omakase", require: false # Omakase Ruby/Rails style linting
  gem "bundler-audit"              # Scans Gemfile.lock against ruby-advisory-db for known CVEs (this is what caught CVE-2026-66066)
  gem "brakeman"                   # Static analysis security scanner for Rails
  gem "pry"                        # Interactive Ruby console/debugger
  gem "rspec-rails"                # RSpec integration for Rails — this project's test framework
  gem "shoulda-matchers"           # One-line RSpec matchers for common validations/associations
  gem "pundit-matchers", "~> 4.0"  # RSpec matchers for Pundit policies
  gem "webmock"                    # Stubs HTTP requests in tests
  gem "vcr"                        # Records/replays HTTP interactions in tests
  gem "factory_bot_rails"          # Test data factories
  gem "faker"                      # Generates realistic fake data for factories
end

group :development do
  gem "web-console" # In-browser console on exception pages
end

group :test do
  gem "capybara"               # System/feature testing
  gem "simplecov"              # Test coverage reporting
  gem "rspec_junit_formatter"  # JUnit-format RSpec output for CI reporting
end
