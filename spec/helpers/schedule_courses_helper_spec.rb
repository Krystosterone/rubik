# frozen_string_literal: true
require "rails_helper"

describe ScheduleCoursesHelper do
  let(:schedule_course) do
    instance_double(ScheduleCourse, code: "LOG430", duration: 4630, index: 2, number: 3, starts_at: WeekTime.new(50))
  end

  describe "#schedule_course_css_class" do
    it "returns the appropriate css class" do
      expect(helper.schedule_course_css_class(schedule_course)).to eq("course-2 from-50 duration-4630")
    end
  end

  describe "#schedule_course_format" do
    it "returns a concatenated code and number" do
      expect(helper.schedule_course_format(schedule_course)).to eq("LOG430-3")
    end
  end
end
