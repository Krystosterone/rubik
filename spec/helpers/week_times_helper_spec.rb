# frozen_string_literal: true

require "rails_helper"

describe WeekTimesHelper do
  let(:week_time) { instance_double(WeekTime, weekday_index: 5, hour: 4, minutes: 0) }

  describe "#week_time_weekday" do
    specify { expect(helper.week_time_weekday(week_time)).to eq("Vendredi") }
  end

  describe "#week_time_format" do
    let(:week_time) { instance_double(WeekTime, weekday_index: 5, hour: 4, minutes: 0) }

    it "returns a concatenation of the weekday name and the time" do
      expect(helper.week_time_format(week_time)).to eq("Vendredi 4:00")
    end
  end
end
