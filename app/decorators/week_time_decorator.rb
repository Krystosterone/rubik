class WeekTimeDecorator < WeekdayTimeDecorator
  def weekday_time
    "#{weekday} #{time}"
  end

  private

  def weekday
    I18n.t("date.day_names")[weekday_index].capitalize
  end
end
