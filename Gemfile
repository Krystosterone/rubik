# frozen_string_literal: true
source "https://rubygems.org"
ruby "2.3.0"

gem "rails", github: "rails/rails", tag: "v5.0.0.rc1"
gem "mysql2", "~> 0.3.18"
gem "sass-rails", "~> 5.0"
gem "compass-rails"
gem "bootstrap-sass"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.1.0"
gem "jquery-rails"
gem "haml-rails"
gem "rails-i18n"
gem "activemodel-serializers-xml"
gem "draper", github: "audionerd/draper", branch: "rails5"
gem "kaminari"
gem "kaminari-i18n"
gem "puma"
gem "email_validator"
gem "airbrake"
gem "sidekiq-unique-jobs"
gem "browserify-rails"
gem "bullet"

# Sidekiq
gem "sidekiq"
gem "sinatra", github: "sinatra/sinatra", require: false

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "rubocop"
  gem "rubocop-rspec"
  gem "letter_opener"
  gem "letter_opener_web", "~> 1.2.0"
end

group :development, :test do
  gem "pry-byebug"
  gem "dotenv-rails"
end

group :test do
  gem "rspec-rails", github: "rspec/rspec-rails", tag: "v3.5.0.beta4" # remove once rails 5 is fully supported
  gem "shoulda-matchers", require: false
  gem "factory_girl_rails"
  gem "database_cleaner"
  gem "rspec-activejob"
  gem "cucumber-rails", require: false
  gem "capybara"
  gem "selenium-webdriver"
  gem "timecop"
  gem "rails-controller-testing"
  gem "simplecov", require: false
  gem "poltergeist"
end

gem "rails_12factor", group: :production # Heroku
