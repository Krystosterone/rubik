# frozen_string_literal: true

ActiveJob::Base.queue_adapter = :inline
Rails.application.config.active_job.queue_adapter = :inline
