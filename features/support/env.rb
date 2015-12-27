require 'cucumber/rails'
require 'capybara/cucumber'
require 'selenium-webdriver'

ActionController::Base.allow_rescue = false

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.run_server = true
Capybara.default_selector = :css
Capybara.default_driver = :chrome
Capybara.javascript_driver  = :chrome
Capybara.server_port = 9887
Capybara.app_host = "http://127.0.0.1:#{Capybara.server_port}"

Cucumber::Rails::Database.javascript_strategy = :truncation
