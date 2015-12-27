require 'rails_helper'

describe ScheduleLeave do
  it_behaves_like 'WeekdayTimeRange'

  describe '.group_by_weekday_index' do
    let(:leaves) do
      [Leave.new(starts_at: 0, ends_at: 250),
       Leave.new(starts_at: 1550, ends_at: 7000),
       Leave.new(starts_at: 9000, ends_at: 10000),
       Leave.new(starts_at: 50, ends_at: 3500)]
    end
    let(:result) { described_class.group_by_weekday_index(leaves) }

    it 'returns a collection of weekdays with schedule courses' do
      expect(result).to eq(0 => [ScheduleLeave.new(starts_at: 0, ends_at: 250),
                                 ScheduleLeave.new(starts_at: 50, ends_at: 1440)],
                           1 => [ScheduleLeave.new(starts_at: 110, ends_at: 1440),
                                 ScheduleLeave.new(starts_at: 0, ends_at: 1440)],
                           2 => [ScheduleLeave.new(starts_at: 0, ends_at: 1440),
                                 ScheduleLeave.new(starts_at: 0, ends_at: 620)],
                           3 => [ScheduleLeave.new(starts_at: 0, ends_at: 1440)],
                           4 => [ScheduleLeave.new(starts_at: 0, ends_at: 1240)],
                           5 => [],
                           6 => [ScheduleLeave.new(starts_at: 360, ends_at: 1360)])
    end
  end
end
