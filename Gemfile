source 'https://rubygems.org'
ruby '2.2.3'

gem 'rails', '4.2.4'
gem 'mysql2', '~> 0.3.18'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'haml-rails'
gem 'rails-i18n'
gem 'draper'
gem 'attribute-defaults'
gem 'route_translator'
gem 'compass-rails', github: 'Compass/compass-rails', branch: 'master'
gem 'bootstrap-sass'
gem 'kaminari'
gem 'kaminari-i18n'
gem 'puma'

# Sidekiq
gem 'sidekiq'
gem 'sinatra', require: false

group :development do
  gem 'bullet'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'guard'
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem 'rubocop'
  gem 'guard-rubocop'
end

group :development, :test do
  gem 'pry-byebug'
end

group :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers', '~> 3.0', require: false
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'rspec-sidekiq'
  gem 'rspec-its'
  gem 'rspec-activejob'
  gem 'cucumber-rails', :require => false
  gem 'capybara'
  gem 'selenium-webdriver'
end

group :production do
  gem 'airbrake'
  gem 'rails_12factor' # Heroku
end
