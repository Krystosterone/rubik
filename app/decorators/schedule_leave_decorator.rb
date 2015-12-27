class ScheduleLeaveDecorator < WeekdayTimeRangeDecorator
  def css_class
    "leave #{super}"
  end
end
