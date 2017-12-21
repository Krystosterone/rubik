# frozen_string_literal: true

module ScheduleLeavesHelper
  include WeekdayTimeRangesHelper

  def schedule_leave_css_class(schedule_leave)
    "leave #{weekday_time_range_css_class(schedule_leave)}"
  end
end
