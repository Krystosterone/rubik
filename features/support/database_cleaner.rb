# frozen_string_literal: true

require "database_cleaner"
require "database_cleaner/cucumber"

DatabaseCleaner.strategy = :truncation
Around do |_scenario, block|
  DatabaseCleaner.cleaning(&block)
end
