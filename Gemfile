source "https://rubygems.org"

ruby "3.2.3"

gem "bootsnap", require: false
gem "pg"
gem "puma", ">= 5.0"
gem "rails", "~> 7.1.3", ">= 7.1.3.2"

group :development do
  gem "web-console"
end

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
end

group :test do
  gem 'rspec-rails', '~> 6.1.0'
  gem 'shoulda-matchers', '~> 6.0'
end
