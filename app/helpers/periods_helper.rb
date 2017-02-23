# frozen_string_literal: true
module PeriodsHelper
  include WeekdayTimesHelper
  include WeekTimesHelper

  def period_time_span(period)
    if period_single_day_span?(period)
      [
        week_time_weekday(period.starts_at),
        weekday_time_format(period.starts_at),
        "-",
        weekday_time_format(period.ends_at),
      ].join(" ")
    else
      "#{week_time_format(period.starts_at)} - #{week_time_format(period.ends_at)}"
    end
  end

  private

  def period_single_day_span?(period)
    period.starts_at.weekday_index == period.ends_at.weekday_index
  end
end
