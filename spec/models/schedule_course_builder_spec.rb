# frozen_string_literal: true

require "rails_helper"

describe ScheduleCourseBuilder do
  describe "#call" do
    subject(:service) { described_class.new(course_groups) }

    let(:course_groups) do
      [
        CourseGroup.new(
          code: "LOG320",
          group: Group.new(number: 1, periods: [
            Period.new(type: "C", starts_at: 0, ends_at: 2000),
            Period.new(type: "Labo", starts_at: 1000, ends_at: 4000),
          ])
        ),
        CourseGroup.new(
          code: "LO640",
          group: Group.new(number: 2, periods: [Period.new(type: "TP", starts_at: 8000, ends_at: 8750)])
        ),
      ]
    end
    let(:expected_result) do
      {
        0 => [
          ScheduleCourse.new(index: 1, code: "LOG320", number: 1, type: "C", starts_at: 0, ends_at: 1440),
          ScheduleCourse.new(index: 1, code: "LOG320", number: 1, type: "Labo", starts_at: 1000, ends_at: 1440),
        ],
        1 => [
          ScheduleCourse.new(index: 1, code: "LOG320", number: 1, type: "C", starts_at: 0, ends_at: 560),
          ScheduleCourse.new(index: 1, code: "LOG320", number: 1, type: "Labo", starts_at: 0, ends_at: 1440)
        ],
        2 => [ScheduleCourse.new(index: 1, code: "LOG320", number: 1, type: "Labo", starts_at: 0, ends_at: 1120)],
        3 => [],
        4 => [],
        5 => [ScheduleCourse.new(index: 2, code: "LO640", number: 2, type: "TP", starts_at: 800, ends_at: 1440)],
        6 => [ScheduleCourse.new(index: 2, code: "LO640", number: 2, type: "TP", starts_at: 0, ends_at: 110)],
      }
    end

    it "returns a collection of weekdays with schedule courses" do
      expect(service.call).to eq(expected_result)
    end
  end
end
