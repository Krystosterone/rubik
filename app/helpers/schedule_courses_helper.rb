# frozen_string_literal: true
module ScheduleCoursesHelper
  include CourseColorsHelper
  include WeekdayTimeRangesHelper

  def schedule_course_css_class(schedule_course, course_colors)
    [
      course_color_css_class(course_colors, schedule_course.code),
      weekday_time_range_css_class(schedule_course),
    ].join(" ")
  end

  def schedule_course_format(schedule_course)
    "#{schedule_course.code}-#{schedule_course.number}"
  end
end
