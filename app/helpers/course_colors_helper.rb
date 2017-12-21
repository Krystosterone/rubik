# frozen_string_literal: true

module CourseColorsHelper
  def course_color_css_class(course_colors, code)
    "course-color-#{course_colors[code]}"
  end
end
