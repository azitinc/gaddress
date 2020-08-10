# frozen_string_literal: true
source "https://rubygems.org"

# Specify your gem's dependencies in gaddress.gemspec
gemspec

gem "rake", "~> 12.0"
gem "rspec", "~> 3.0"
gem 'rubocop', '~> 0.89.0', require: false

group :development do
  gem 'yard'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end
