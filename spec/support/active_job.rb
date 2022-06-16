# frozen_string_literal: true

RSpec.configure do |config|
  config.include(RSpec::ActiveJob)
  config.include(ActiveJob::TestHelper)

  config.after do
    ActiveJob::Base.queue_adapter.enqueued_jobs = []
    ActiveJob::Base.queue_adapter.performed_jobs = []
  end
end
