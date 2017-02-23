# frozen_string_literal: true
module WeekTimesHelper
  include WeekdayTimesHelper

  def week_time_weekday(week_time)
    I18n.t("date.day_names")[week_time.weekday_index].capitalize
  end

  def week_time_format(week_time)
    "#{week_time_weekday(week_time)} #{weekday_time_format(week_time)}"
  end
end
