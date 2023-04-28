# frozen_string_literal: true

source "https://rubygems.org"
ruby "2.7.6"

gem "airbrake"
gem "autoprefixer-rails"
gem "bootstrap-sass"
gem "browserify-rails"
gem "bullet"
gem "email_validator"
gem "haml_lint"
gem "haml-rails"
gem "jquery-rails"
gem "kaminari"
gem "kaminari-i18n"
gem "listen"
gem "mailkick"
gem "mysql2"
gem "omniauth", "~> 2.0"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection", "~> 1.0"
gem "puma", "~> 6.2.2"
gem "rails", "~> 7"
gem "rails-i18n"
gem "sass-rails"
gem "uglifier"

# Sidekiq
gem "sidekiq"
gem "sinatra"

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
  gem "letter_opener_web"
end

group :development, :test do
  gem "dotenv-rails"
  gem "phantomjs", require: "phantomjs/poltergeist"
  gem "pry-byebug"
  gem "rubocop", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :test do
  gem "capybara"
  gem "codecov", require: false
  gem "cucumber-rails", "~> 2.0", require: false
  gem "database_cleaner"
  gem "factory_bot_rails", "~> 6.2.0"
  gem "fakeredis", require: "fakeredis/rspec"
  gem "poltergeist"
  gem "rails-controller-testing"
  gem "rspec-html-matchers"
  gem "rspec_junit_formatter"
  gem "rspec-rails"
  gem "rspec-sidekiq"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "timecop"
end

gem "rails_12factor", group: :production # Heroku
