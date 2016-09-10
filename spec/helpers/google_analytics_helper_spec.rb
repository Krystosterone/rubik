require "rails_helper"

describe GoogleAnalyticsHelper do
  describe "#ga_tracking_id" do
    before do
      @old_ga_tracking_id = Rails.application.config.ga_tracking_id
      Rails.application.config.ga_tracking_id = "Test-GA-ID"
    end
    after { Rails.application.config.ga_tracking_id = @old_ga_tracking_id }

    specify { expect(ga_tracking_id).to eq("Test-GA-ID") }
  end
end
