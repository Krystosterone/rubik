# frozen_string_literal: true
require "rails_helper"

describe GoogleServicesHelper do
  describe "#analytics_tracking_id" do
    before do
      @old_ga_tracking_id = Rails.application.config.x.google.analytics_tracking_id
      Rails.application.config.x.google.analytics_tracking_id = "Test-GA-ID"
    end
    after { Rails.application.config.x.google.analytics_tracking_id = @old_ga_tracking_id }

    specify { expect(analytics_tracking_id).to eq("Test-GA-ID") }
  end
end
