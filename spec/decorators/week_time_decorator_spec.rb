# frozen_string_literal: true
require "rails_helper"

describe WeekTimeDecorator do
  subject(:decorator) { described_class.new(week_time) }
  let(:week_time) { instance_double(WeekTime, weekday_index: 5, hour: 4, minutes: 0) }

  describe "#weekday" do
    specify { expect(decorator.weekday).to eq("Vendredi") }
  end

  describe "#weekday_time" do
    subject(:decorator) { described_class.new(week_time) }
    let(:week_time) { instance_double(WeekTime, weekday_index: 5, hour: 4, minutes: 0) }

    it "returns a concatenation of the weekday name and the time" do
      expect(decorator.weekday_time).to eq("Vendredi 4:00")
    end
  end
end
