# frozen_string_literal: true
require "simplecov"
require "cucumber/rails"
require "capybara/cucumber"

ActionController::Base.allow_rescue = false

if ENV["DEBUG_BROWSER_TESTS"] == "1"
  require "selenium-webdriver"

  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  Capybara.run_server = true
  Capybara.default_driver = :chrome
  Capybara.javascript_driver = :chrome
else
  require "capybara/poltergeist"

  Capybara.default_driver = :poltergeist
  Capybara.javascript_driver = :poltergeist
end

Capybara.default_selector = :css
Capybara.server_port = 9887
Capybara.app_host = "http://127.0.0.1:#{Capybara.server_port}"

Cucumber::Rails::Database.javascript_strategy = :truncation
