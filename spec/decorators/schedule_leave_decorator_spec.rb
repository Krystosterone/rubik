require "rails_helper"

describe ScheduleLeaveDecorator do
  it_behaves_like "WeekdayTimeRangeDecorator", decorated_class: ScheduleLeave

  describe "#css_class" do
    subject(:decorator) { described_class.new(weekday_time_range) }
    let(:weekday_time_range) { instance_double(ScheduleLeave, starts_at: WeekTime.new(1000), duration: 4000) }

    it "returns the class with restricted starts_at" do
      expect(decorator.css_class).to eq("leave from-1000 duration-4000")
    end
  end
end
