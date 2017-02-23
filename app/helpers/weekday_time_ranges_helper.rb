# frozen_string_literal: true
module WeekdayTimeRangesHelper
  include WeekdayTimesHelper

  def weekday_time_css_class(weekday_time)
    "from-#{weekday_time.starts_at} duration-#{weekday_time.duration}"
  end

  def weekday_time_time_span(weekday_time)
    "#{weekday_time_format(weekday_time.starts_at)} - #{weekday_time_format(weekday_time.ends_at)}"
  end
end
