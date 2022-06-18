# frozen_string_literal: true

require "simplecov"

if ENV["CIRCLE_ARTIFACTS"]
  coverage_directory = File.join(ENV["CIRCLE_ARTIFACTS"], "coverage")
  SimpleCov.coverage_dir(coverage_directory)
end

SimpleCov.start("rails") do
  refuse_coverage_drop

  add_filter "lib/tasks/cucumber.rake"
  add_group "Middleware", "app/middlewares"
end

if ENV["CIRCLECI"]
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end
