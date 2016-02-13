source "https://rubygems.org"
ruby "2.3.0"

gem "rails", github: "rails/rails"
gem "mysql2", "~> 0.3.18"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.1.0"
gem "haml-rails"
gem "rails-i18n"
gem "activemodel-serializers-xml", github: "rails/activemodel-serializers-xml" # needed for draper,
# remove once rails 5 is fully supported
gem "draper", github: "audionerd/draper", branch: "rails5"
gem "attribute-defaults"
gem "compass-rails"
gem "bootstrap-sass"
gem "kaminari", github: "amatsuda/kaminari" # remove once rails 5 is fully supported
gem "kaminari-i18n"
gem "puma"
gem "email_validator"
gem "airbrake"

# Sidekiq
gem "sidekiq"
gem "sinatra", github: "sinatra/sinatra", require: false

group :development do
  gem "bullet"
  gem "better_errors"
  gem "binding_of_caller"
  gem "guard"
  # gem "guard-rspec" Remove temporarily until rails 5 is fully supported
  gem "terminal-notifier-guard"
  gem "rubocop"
  gem "guard-rubocop"
  gem "rubocop-rspec" # Disable until rails 5 is fully supported
  gem "letter_opener"
  gem "letter_opener_web", "~> 1.2.0"
end

group :development, :test do
  gem "pry-byebug"
  gem "dotenv-rails"
end

group :test do
  # All of those are needed for rails 5 support
  # Remove once fully supported and replace by 'gem "rspec-rails""
  gem "rspec-rails", github: "rspec/rspec-rails"
  gem "rspec-core", github: "rspec/rspec-core"
  gem "rspec-expectations", github: "rspec/rspec-expectations"
  gem "rspec-mocks", github: "rspec/rspec-mocks"
  gem "rspec-support", github: "rspec/rspec-support"

  gem "shoulda-matchers", require: false
  gem "factory_girl_rails"
  gem "database_cleaner"
  gem "rspec-activejob"
  gem "cucumber-rails", require: false
  gem "capybara"
  gem "selenium-webdriver"
  gem "timecop"
  gem "rails-controller-testing"
end

gem "rails_12factor", group: :production # Heroku
