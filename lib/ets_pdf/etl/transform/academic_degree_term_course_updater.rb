# frozen_string_literal: true
class EtsPdf::Etl::Transform::AcademicDegreeTermCourseUpdater
  def initialize(academic_degree_term, course_data)
    @academic_degree_term = academic_degree_term
    @course_data = course_data
  end

  def execute
    @academic_degree_term.academic_degree_term_courses.where(course: course).first_or_initialize
  end

  private

  def course
    Course.where(code: @course_data.code).first_or_create!
  end
end
