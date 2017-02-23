# frozen_string_literal: true
class ScheduleDecorator < Draper::Decorator
  include ScheduleWeekdaysHelper

  delegate_all

  def css_class
    classes = %W(from-#{from} duration-#{duration})
    classes << "collapsible" if collapsible?
    classes.join(" ")
  end

  def hours
    (starts_at.hour..restricted_ends_at).collect { |hour| "#{hour.to_s.rjust(2, '0')}:00" }
  end

  def duration
    (restricted_ends_at - starts_at.hour) * 60
  end

  private

  def from
    starts_at.hour * 60
  end

  def collapsible?
    weekdays.select(&:weekend?).all?(&method(:schedule_weekday_collapsible?))
  end

  def restricted_ends_at
    [ends_at.hour, 23].min
  end
end
