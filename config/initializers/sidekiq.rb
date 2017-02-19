# frozen_string_literal: true
require "sidekiq"
require "sidekiq/web"

if Rails.env.development? && ENV["INLINE_JOBS"] != "0"
  require "sidekiq/testing"
  Sidekiq::Testing.inline!
end

if Rails.env.production?
  Sidekiq.default_worker_options = {
    unique: :until_executing,
    unique_args: ->(args) { args.first.except("job_id") }
  }

  SidekiqUniqueJobs.config.unique_args_enabled = true
end
