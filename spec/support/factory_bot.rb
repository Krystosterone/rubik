# frozen_string_literal: true

require "shoulda-matchers"

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.start
    FactoryBot.lint(traits: true, verbose: true)
  ensure
    DatabaseCleaner.clean
  end
end
