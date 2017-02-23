# frozen_string_literal: true
class WeekTimeDecorator < Draper::Decorator
  include WeekdayTimesHelper

  delegate_all

  def weekday
    I18n.t("date.day_names")[weekday_index].capitalize
  end

  def weekday_time
    "#{weekday} #{weekday_time_format(self)}"
  end
end
