# frozen_string_literal: true
class WeekdayTimeRangeDecorator < Draper::Decorator
  delegate_all
  decorates_association :starts_at
  decorates_association :ends_at

  def css_class
    "from-#{starts_at} duration-#{duration}"
  end

  def time_span
    "#{starts_at.time} - #{ends_at.time}"
  end

  def to_partial_path
    "schedules/#{object.class.name.underscore}"
  end
end
