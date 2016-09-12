require "simplecov"

if ENV["CIRCLE_ARTIFACTS"]
  coverage_directory = File.join(ENV["CIRCLE_ARTIFACTS"], "coverage")
  SimpleCov.coverage_dir(coverage_directory)
end

SimpleCov.start("rails") { add_filter "lib/tasks/cucumber.rake" }
