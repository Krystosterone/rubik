# frozen_string_literal: true
module MemoizedCourseScopes
  extend ActiveSupport::Concern

  def mandatory_courses
    @mandatory_courses ||= courses.select(&:mandatory?)
  end

  def optional_courses
    @optional_courses ||= courses.reject(&:mandatory?)
  end
end
