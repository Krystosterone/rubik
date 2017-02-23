# frozen_string_literal: true
source "https://rubygems.org"
ruby "2.3.0"

gem "airbrake"
gem "autoprefixer-rails"
gem "bootstrap-sass"
gem "browserify-rails"
gem "bullet"
gem "coffee-rails", "~> 4.1.0"
gem "email_validator"
gem "haml-rails"
gem "jquery-rails"
gem "kaminari"
gem "kaminari-i18n"
gem "mysql2", "~> 0.3.18"
gem "omniauth"
gem "omniauth-google-oauth2"
gem "puma"
gem "rails"
gem "rails-i18n"
gem "sass-rails", "~> 5.0"
gem "sidekiq-unique-jobs"
gem "uglifier", ">= 1.3.0"

# Sidekiq
gem "sidekiq"
gem "sinatra", "2.0.0.beta2"

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
  gem "letter_opener_web", "~> 1.2.0"
  gem "rubocop"
  gem "rubocop-rspec"
end

group :development, :test do
  gem "dotenv-rails"
  gem "pry-byebug"
end

group :test do
  gem "capybara"
  gem "codecov", require: false
  gem "cucumber-rails", require: false
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "fakeredis"
  gem "poltergeist"
  gem "rails-controller-testing"
  gem "rspec-activejob"
  gem "rspec-rails"
  gem "selenium-webdriver"
  gem "shoulda-matchers", require: false
  gem "simplecov", require: false
  gem "timecop"
end

gem "rails_12factor", group: :production # Heroku
