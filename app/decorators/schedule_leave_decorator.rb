# frozen_string_literal: true
class ScheduleLeaveDecorator < WeekdayTimeRangeDecorator
  def css_class
    "leave #{super}"
  end
end
