# frozen_string_literal: true
require "rails_helper"

describe ScheduleCourse do
  it_behaves_like "WeekdayTimeRange"

  describe "#new" do
    context "when passing in some attributes" do
      subject { described_class.new(index: 3, code: "LOG320", number: 1, type: "TP") }

      its(:index) { is_expected.to eq(3) }
      its(:code) { is_expected.to eq("LOG320") }
      its(:number) { is_expected.to eq(1) }
      its(:type) { is_expected.to eq("TP") }
    end
  end

  describe "#==" do
    subject(:schedule_course) { described_class.new(index: 3, code: "LOG320", number: 1, type: "TP") }

    context "when instances do not match" do
      specify { expect(schedule_course).not_to eq(described_class.new) }
    end

    context "when instance do match" do
      let(:other) { described_class.new(index: 3, code: "LOG320", number: 1, type: "TP") }
      specify { expect(schedule_course).to eq(other) }
    end
  end

  describe ".group_by_weekday_index" do
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
    let(:actual_result) { described_class.group_by_weekday_index(course_groups) }
    let(:expected_result) do
      {
        0 => [
          described_class.new(index: 1, code: "LOG320", number: 1, type: "C", starts_at: 0, ends_at: 1440),
          described_class.new(index: 1, code: "LOG320", number: 1, type: "Labo", starts_at: 1000, ends_at: 1440),
        ],
        1 => [
          described_class.new(index: 1, code: "LOG320", number: 1, type: "C", starts_at: 0, ends_at: 560),
          described_class.new(index: 1, code: "LOG320", number: 1, type: "Labo", starts_at: 0, ends_at: 1440)
        ],
        2 => [described_class.new(index: 1, code: "LOG320", number: 1, type: "Labo", starts_at: 0, ends_at: 1120)],
        3 => [],
        4 => [],
        5 => [described_class.new(index: 2, code: "LO640", number: 2, type: "TP", starts_at: 800, ends_at: 1440)],
        6 => [described_class.new(index: 2, code: "LO640", number: 2, type: "TP", starts_at: 0, ends_at: 110)],
      }
    end

    it "returns a collection of weekdays with schedule courses" do
      expect(actual_result).to eq(expected_result)
    end
  end
end
