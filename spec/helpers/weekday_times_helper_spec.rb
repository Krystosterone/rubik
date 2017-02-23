# frozen_string_literal: true
require "rails_helper"

describe WeekdayTimesHelper do
  describe "#weekday_time_format" do
    context "with minutes less than 10" do
      let(:weekday_time) { instance_double(WeekdayTime, hour: 5, minutes: 9) }

      it "returns a formatted time padded for minutes" do
        expect(helper.weekday_time_format(weekday_time)).to eq("5:09")
      end
    end

    context "with minutes equal or grater to 10" do
      let(:weekday_time) { instance_double(WeekdayTime, hour: 11, minutes: 34) }

      it "returns a formatted time" do
        expect(helper.weekday_time_format(weekday_time)).to eq("11:34")
      end
    end
  end
end
