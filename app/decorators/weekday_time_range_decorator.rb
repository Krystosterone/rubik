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

  def weekday_time_span
    if single_day_span?
      "#{starts_at.weekday} #{starts_at.time} - #{ends_at.time}"
    else
      "#{starts_at.weekday_time} - #{ends_at.weekday_time}"
    end
  end

  def to_partial_path
    "schedules/#{object.class.name.underscore}"
  end

  private

  def single_day_span?
    starts_at.weekday_index == ends_at.weekday_index
  end
end
