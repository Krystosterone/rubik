# frozen_string_literal: true

module WeekdayTimeRangesHelper
  include WeekdayTimesHelper

  def weekday_time_range_css_class(weekday_time_range)
    "from-#{weekday_time_range.starts_at} duration-#{weekday_time_range.duration}"
  end

  def weekday_time_range_format(weekday_time_range)
    [
      weekday_time_format(weekday_time_range.starts_at),
      weekday_time_format(weekday_time_range.ends_at),
    ].join(" - ")
  end
end
