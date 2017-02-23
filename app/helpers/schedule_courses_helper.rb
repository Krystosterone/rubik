# frozen_string_literal: true
module ScheduleCoursesHelper
  include WeekdayTimeRangesHelper

  def schedule_course_css_class(schedule_course)
    "course-#{schedule_course.index} #{weekday_time_range_css_class(schedule_course)}"
  end

  def schedule_course_format(schedule_course)
    "#{schedule_course.code}-#{schedule_course.number}"
  end
end
