# frozen_string_literal: true
class WeekTimeDecorator < WeekdayTimeDecorator
  def weekday
    I18n.t("date.day_names")[weekday_index].capitalize
  end

  def weekday_time
    "#{weekday} #{time}"
  end
end
