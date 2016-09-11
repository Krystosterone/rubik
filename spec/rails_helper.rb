# frozen_string_literal: true
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "spec_helper"
require "rspec/rails"
require "rspec/active_job"

ActiveRecord::Migration.maintain_test_schema!
RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
end

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
