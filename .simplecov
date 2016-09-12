require "simplecov"

if ENV["CIRCLE_ARTIFACTS"]
  coverage_directory = File.join(ENV["CIRCLE_ARTIFACTS"], "coverage")
  SimpleCov.coverage_dir(coverage_directory)
end

SimpleCov.start("rails") do
  add_filter "lib/tasks/cucumber.rake"

  add_group "Decorators", "app/decorators"
  add_group "Middleware", "app/middleware"
end

if ENV["CIRCLECI"]
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end
