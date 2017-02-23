# frozen_string_literal: true
module SchedulesHelper
  include ScheduleWeekdaysHelper

  def schedule_css_class(schedule)
    classes = %W(from-#{schedule_from(schedule)} duration-#{schedule_duration(schedule)})
    classes << "collapsible" if schedule_collapsible?(schedule)
    classes.join(" ")
  end

  def schedule_hours(schedule)
    (schedule.starts_at.hour..schedule_restricted_ends_at(schedule)).collect do |hour|
      "#{hour.to_s.rjust(2, '0')}:00"
    end
  end

  private

  def schedule_duration(schedule)
    (schedule_restricted_ends_at(schedule) - schedule.starts_at.hour) * 60
  end

  def schedule_from(schedule)
    schedule.starts_at.hour * 60
  end

  def schedule_collapsible?(schedule)
    schedule.weekdays.select(&:weekend?).all?(&method(:schedule_weekday_collapsible?))
  end

  def schedule_restricted_ends_at(schedule)
    [schedule.ends_at.hour, 23].min
  end
end
