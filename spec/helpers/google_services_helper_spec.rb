# frozen_string_literal: true
require "rails_helper"

describe GoogleServicesHelper do
  describe "#ad_client" do
    before do
      @old_google_ad_client = Rails.application.config.x.google.ad_client
      Rails.application.config.x.google.ad_client = "Test-CLIENT-ID"
    end
    after { Rails.application.config.x.google.ad_client = @old_google_ad_client }

    specify { expect(ad_client).to eq("Test-CLIENT-ID") }
  end

  describe "#analytics_tracking_id" do
    before do
      @old_ga_tracking_id = Rails.application.config.x.google.analytics_tracking_id
      Rails.application.config.x.google.analytics_tracking_id = "Test-GA-ID"
    end
    after { Rails.application.config.x.google.analytics_tracking_id = @old_ga_tracking_id }

    specify { expect(analytics_tracking_id).to eq("Test-GA-ID") }
  end
end
