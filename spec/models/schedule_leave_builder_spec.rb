# frozen_string_literal: true
require "rails_helper"

describe ScheduleLeaveBuilder do
  describe "#call" do
    subject(:service) { described_class.new(leaves) }
    let(:expected_result) do
      {
        0 => [
          ScheduleLeave.new(starts_at: 0, ends_at: 250),
          ScheduleLeave.new(starts_at: 50, ends_at: 1440),
        ],
        1 => [
          ScheduleLeave.new(starts_at: 110, ends_at: 1440),
          ScheduleLeave.new(starts_at: 0, ends_at: 1440),
        ],
        2 => [
          ScheduleLeave.new(starts_at: 0, ends_at: 1440),
          ScheduleLeave.new(starts_at: 0, ends_at: 620),
        ],
        3 => [ScheduleLeave.new(starts_at: 0, ends_at: 1440)],
        4 => [ScheduleLeave.new(starts_at: 0, ends_at: 1240)],
        5 => [],
        6 => [ScheduleLeave.new(starts_at: 360, ends_at: 1360)],
      }
    end
    let(:leaves) do
      [
        Leave.new(starts_at: 0, ends_at: 250),
        Leave.new(starts_at: 1550, ends_at: 7000),
        Leave.new(starts_at: 9000, ends_at: 10_000),
        Leave.new(starts_at: 50, ends_at: 3500),
      ]
    end

    it "returns a collection of weekdays with schedule courses" do
      expect(service.call).to eq(expected_result)
    end
  end
end
