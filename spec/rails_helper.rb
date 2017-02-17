# frozen_string_literal: true
require "simplecov"

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"
require "rspec/active_job"

abort("The Rails environment is running in production mode!") if Rails.env.production?

ActiveRecord::Migration.maintain_test_schema!
Rails.application.load_tasks

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end

Dir[Rails.root.join("spec", "support", "**", "*.rb")].each { |f| require f }
