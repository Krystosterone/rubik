# frozen_string_literal: true

class CourseColorMap
  delegate :[], to: :indexes

  def initialize(courses)
    @courses = courses
  end

  def to_h
    indexes
  end

  private

  def indexes
    @indexes ||= @courses.map.with_index(&method(:calculate_color_index)).to_h
  end

  def calculate_color_index(course, index)
    [course.code, (360 / @courses.count).floor * index]
  end
end
