# frozen_string_literal: true
require "rails_helper"

describe ScheduleLeavesHelper do
  let(:schedule_leave) { instance_double(ScheduleLeave, duration: 4630, starts_at: WeekTime.new(50)) }

  describe "#schedule_leave_css_class" do
    it "returns the appropriate css class" do
      expect(helper.schedule_leave_css_class(schedule_leave)).to eq("leave from-50 duration-4630")
    end
  end
end
