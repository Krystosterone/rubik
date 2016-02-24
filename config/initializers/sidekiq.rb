require "sidekiq"
require "sidekiq/web"

if Rails.env.development?
  require "sidekiq/testing"
  Sidekiq::Testing.inline!
elsif Rails.env.production?
  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    [user, password] == [ENV.fetch("SIDEKIQ_USERNAME"), ENV.fetch("SIDEKIQ_PASSWORD")]
  end

  Sidekiq.default_worker_options = {
    unique: :until_executing,
    unique_args: ->(args) { args.first.except("job_id") }
  }

  SidekiqUniqueJobs.config.unique_args_enabled = true
end
