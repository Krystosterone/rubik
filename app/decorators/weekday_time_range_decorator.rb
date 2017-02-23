# frozen_string_literal: true
class WeekdayTimeRangeDecorator < Draper::Decorator
  include WeekdayTimesHelper
  include WeekTimesHelper

  delegate_all
  decorates_association :starts_at, with: WeekTimeDecorator
  decorates_association :ends_at, with: WeekTimeDecorator

  def css_class
    "from-#{starts_at} duration-#{duration}"
  end

  def time_span
    "#{weekday_time_format(starts_at)} - #{weekday_time_format(ends_at)}"
  end

  def weekday_time_span
    if single_day_span?
      "#{week_time_weekday(starts_at)} #{weekday_time_format(starts_at)} - #{weekday_time_format(ends_at)}"
    else
      "#{week_time_format(starts_at)} - #{week_time_format(ends_at)}"
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
