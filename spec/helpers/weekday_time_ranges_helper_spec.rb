# frozen_string_literal: true
describe WeekdayTimeRangesHelper do
  let(:weekday_time_range) do
    instance_double(WeekdayTimeRange, duration: 4630, ends_at: WeekTime.new(4680), starts_at: WeekTime.new(50))
  end

  describe "#weekday_time_range_css_class" do
    it "returns the appropriate css class" do
      expect(helper.weekday_time_range_css_class(weekday_time_range)).to eq("from-50 duration-4630")
    end
  end

  describe "#weekday_time_range_format" do
    it "returns a concatenated starts_at time and ends_at time" do
      expect(helper.weekday_time_range_format(weekday_time_range)).to eq("0:50 - 6:00")
    end
  end
end
