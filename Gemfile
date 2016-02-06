source "https://rubygems.org"
ruby "2.2.3"

gem "rails", "4.2.5.1"
gem "mysql2", "~> 0.3.18"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.1.0"
gem "jquery-rails"
gem "turbolinks"
gem "haml-rails"
gem "rails-i18n"
gem "draper"
gem "attribute-defaults"
gem "route_translator"
gem "compass-rails"
gem "bootstrap-sass"
gem "kaminari"
gem "kaminari-i18n"
gem "puma"
gem "email_validator"
gem "airbrake"

# Sidekiq
gem "sidekiq"
gem "sinatra", require: false

group :development do
  gem "bullet"
  gem "better_errors"
  gem "binding_of_caller"
  gem "guard"
  gem "guard-rspec"
  gem "terminal-notifier-guard"
  gem "rubocop"
  gem "guard-rubocop"
  gem "rubocop-rspec"
  gem "letter_opener"
  gem "letter_opener_web", "~> 1.2.0"
end

group :development, :test do
  gem "pry-byebug"
  gem "dotenv-rails"
end

group :test do
  gem "rspec-rails"
  gem "shoulda-matchers", "~> 3.0", require: false
  gem "factory_girl_rails"
  gem "database_cleaner"
  gem "rspec-sidekiq"
  gem "rspec-its"
  gem "rspec-activejob"
  gem "cucumber-rails", require: false
  gem "capybara"
  gem "selenium-webdriver"
  gem "test_after_commit"
  gem "timecop"
end

gem "rails_12factor", group: :production  # Heroku
