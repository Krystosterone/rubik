# frozen_string_literal: true
require "rails_helper"

describe Schedule do
  it { is_expected.to belong_to(:agenda) }
  it { is_expected.to serialize(:course_groups).as(CourseGroupsSerializer) }

  context "with some courses and leaves" do
    subject(:schedule) { described_class.new(course_groups: course_groups, agenda: agenda) }
    let(:course_groups) do
      [
        CourseGroup.new(
          code: "LOG120",
          group: Group.new(number: 1, periods: [
            Period.new(type: "C", starts_at: 6500, ends_at: 7000),
            Period.new(type: "Labo", starts_at: 10_000, ends_at: 10_050),
          ])
        )
      ]
    end
    let(:leaves) do
      [Leave.new(starts_at: 1500, ends_at: 1600),
       Leave.new(starts_at: 6000, ends_at: 7000)]
    end
    let(:agenda) { Agenda.new(leaves: leaves) }
    let(:expected_weekdays) do
      [
        ScheduleWeekday.new(index: 0, periods: []),
        ScheduleWeekday.new(
          index: 1,
          periods: [ScheduleLeave.new(starts_at: 60, ends_at: 160)]
        ),
        ScheduleWeekday.new(index: 2, periods: []),
        ScheduleWeekday.new(index: 3, periods: []),
        ScheduleWeekday.new(
          index: 4,
          periods: [
            ScheduleCourse.new(
              index: 1,
              code: "LOG120",
              number: 1,
              type: "C",
              starts_at: 740,
              ends_at: 1240
            ),
            ScheduleLeave.new(starts_at: 240, ends_at: 1240),
          ]
        ),
        ScheduleWeekday.new(index: 5, periods: []),
        ScheduleWeekday.new(
          index: 6,
          periods: [
            ScheduleCourse.new(
              index: 1,
              code: "LOG120",
              number: 1,
              type: "Labo",
              starts_at: 1360,
              ends_at: 1410
            ),
          ]
        ),
      ]
    end

    its(:starts_at) { is_expected.to eq(60) }
    its(:ends_at) { is_expected.to eq(1410) }
    its(:duration) { is_expected.to eq(1320) }

    describe "#weekdays" do
      it "groups them per weekdays" do
        expect(schedule.weekdays).to eq(expected_weekdays)
      end
    end
  end
end
