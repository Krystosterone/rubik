# frozen_string_literal: true
module ScheduleWeekdaysHelper
  def schedule_weekday_collapsible?(schedule_weekday)
    schedule_weekday.empty?
  end

  def schedule_weekday_backdrop_class(schedule_weekday)
    schedule_weekday_weekend_class(schedule_weekday)
  end

  def schedule_weekday_css_class(schedule_weekday)
    "weekday-#{schedule_weekday.index} #{schedule_weekday_weekend_class(schedule_weekday)}".strip
  end

  def schedule_weekday_name(schedule_weekday)
    I18n.t("date.day_names")[schedule_weekday.index].capitalize
  end

  private

  def schedule_weekday_weekend_class(schedule_weekday)
    "weekend" if schedule_weekday.weekend?
  end
end
