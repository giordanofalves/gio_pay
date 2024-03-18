source "https://rubygems.org"

ruby "3.2.3"

gem "bootsnap", require: false
gem "pg"
gem 'progress_bar'
gem "puma", ">= 5.0"
gem "rails", "~> 7.1.3", ">= 7.1.3.2"
gem "sidekiq"
gem "sprockets-rails"

group :development do
  gem 'annotate'
  gem "web-console"
end

group :development, :test do
  gem "factory_bot_rails"
  gem 'faker'
  gem "debug", platforms: %i[ mri windows ]
  gem 'pry', '~> 0.14.2'
end

group :test do
  gem 'rspec-rails', '~> 6.1.0'
  gem 'shoulda-matchers', '~> 6.0'
end
