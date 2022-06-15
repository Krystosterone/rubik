# frozen_string_literal: true

module GoogleServicesHelper
  delegate :analytics_tracking_id, to: "Rails.application.config.x.google"
end
