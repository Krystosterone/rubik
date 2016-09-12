require "simplecov"

if ENV["CIRCLE_ARTIFACTS"]
  coverage_directory = File.join(ENV["CIRCLE_ARTIFACTS"], "coverage")
  SimpleCov.coverage_dir(coverage_directory)
end

SimpleCov.start("rails") do
  # Looks like SimpleCov, for whatever reason, reports less than 100% test coverage on the "etl:pdf" rake task
  # when running the entire test suite. When running the single file, it reports 100%.
  # TODO: Investigate why this is happening but until then, disable coverage calculation on "lib/tasks"
  #
  # Also, apparently it's not a good thing to directly test rake tasks anyways.
  # (https://github.com/colszowka/simplecov/issues/369)
  add_filter "lib/tasks"

  add_group "Decorators", "app/decorators"
  add_group "Middleware", "app/middleware"
end

if ENV["CIRCLECI"]
  require "codecov"
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end
