require "rails_helper"

describe ScheduleCourseDecorator do
  it_behaves_like "WeekdayTimeRangeDecorator", decorated_class: ScheduleCourse

  describe "#css_class" do
    subject(:decorator) { described_class.new(weekday_time_range) }
    let(:weekday_time_range) do
      instance_double(ScheduleCourse, index: 3, starts_at: WeekTime.new(1000), duration: 4000)
    end

    it "returns the class with restricted starts_at" do
      expect(decorator.css_class).to eq("course-3 from-1000 duration-4000")
    end
  end

  describe "#course" do
    subject { described_class.new(schedule_course) }
    let(:schedule_course) { ScheduleCourse.new(code: "LOG120", number: 2) }

    its(:course) { is_expected.to eq("LOG120-2") }
  end
end
