class ScheduleWeekdayDecorator < Draper::Decorator
  delegate_all
  decorates_association :periods

  def collapsible?
    empty?
  end

  def backdrop_class
    weekend_class
  end

  def css_class
    "weekday-#{index} #{weekend_class}".strip
  end

  def name
    I18n.t('date.day_names')[index].capitalize
  end

  private

  def weekend_class
    'weekend' if weekend?
  end
end
