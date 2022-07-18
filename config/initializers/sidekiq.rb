# frozen_string_literal: true

require "sidekiq"
require "sidekiq/web"

if Rails.env.development? && ENV["INLINE_JOBS"]
  require "sidekiq/testing"
  Sidekiq::Testing.inline!
end

Sidekiq.default_job_options = {
  unique: :until_executing,
  unique_args: ->(args) { args.first.except("job_id") }
}
