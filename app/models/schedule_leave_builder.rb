# frozen_string_literal: true
class ScheduleLeaveBuilder
  def initialize(leaves)
    @leaves = leaves
  end

  def call
    weekdays = (0..6).collect { |index| [index, []] }.to_h
    @leaves.each do |leave|
      leave.to_weekday_time_ranges.collect do |weekday_index, weekday_time_range|
        weekdays[weekday_index] << ScheduleLeave.new(
          starts_at: weekday_time_range.starts_at,
          ends_at: weekday_time_range.ends_at
        )
      end
    end
    weekdays
  end
end
