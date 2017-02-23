# frozen_string_literal: true
require "rails_helper"

describe PeriodsHelper do
  describe "#period_time_span" do
    let(:period) { instance_double(Period, starts_at: WeekTime.new(50), ends_at: WeekTime.new(600)) }

    context "when the weekdays match" do
      it "returns a concatenated starts_at time and ends_at time" do
        expect(helper.period_time_span(period)).to eq("Dimanche 0:50 - 10:00")
      end
    end

    context "when the weekdays differ" do
      let(:period) { instance_double(Period, starts_at: WeekTime.new(50), ends_at: WeekTime.new(4680)) }

      it "returns a concatenated starts_at time and ends_at time" do
        expect(helper.period_time_span(period)).to eq("Dimanche 0:50 - Mercredi 6:00")
      end
    end
  end
end
