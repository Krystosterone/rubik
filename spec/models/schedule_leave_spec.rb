require "rails_helper"

describe ScheduleLeave do
  it_behaves_like "WeekdayTimeRange"

  describe ".group_by_weekday_index" do
    let(:leaves) do
      [
        Leave.new(starts_at: 0, ends_at: 250),
        Leave.new(starts_at: 1550, ends_at: 7000),
        Leave.new(starts_at: 9000, ends_at: 10_000),
        Leave.new(starts_at: 50, ends_at: 3500),
      ]
    end
    let(:actual_result) { described_class.group_by_weekday_index(leaves) }
    let(:expected_result) do
      {
        0 => [
          described_class.new(starts_at: 0, ends_at: 250),
          described_class.new(starts_at: 50, ends_at: 1440),
        ],
        1 => [
          described_class.new(starts_at: 110, ends_at: 1440),
          described_class.new(starts_at: 0, ends_at: 1440),
        ],
        2 => [
          described_class.new(starts_at: 0, ends_at: 1440),
          described_class.new(starts_at: 0, ends_at: 620),
        ],
        3 => [described_class.new(starts_at: 0, ends_at: 1440)],
        4 => [described_class.new(starts_at: 0, ends_at: 1240)],
        5 => [],
        6 => [described_class.new(starts_at: 360, ends_at: 1360)],
      }
    end

    it "returns a collection of weekdays with schedule courses" do
      expect(actual_result).to eq(expected_result)
    end
  end
end
