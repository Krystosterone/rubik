# frozen_string_literal: true
module WeekdayTimesHelper
  def weekday_time_format(weekday_time)
    "#{weekday_time.hour}:#{weekday_time.minutes.to_s.rjust(2, '0')}"
  end
end
