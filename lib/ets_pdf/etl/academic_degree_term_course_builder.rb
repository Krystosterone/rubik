# frozen_string_literal: true

class EtsPdf::Etl::AcademicDegreeTermCourseBuilder < SimpleClosure
  SKIP_COURSES = %w[
    CTN791
    CTN793
    CTN794
    ELE791
    ELE792
    ELE795
    ENT301
    ENT302
    ENT303
    ENT304
    GOL791
    GOL792
    GOL796
    GPA791
    GPA792
    GTI791
    GTI792
    GTI795
    GTS792
    LOG791
    LOG792
    LOG795
    MEC791
    PRE010
  ].freeze

  def initialize(academic_degree_term, parsed_lines)
    super()
    @academic_degree_term = academic_degree_term
    @parsed_lines = parsed_lines
  end

  def call
    @parsed_lines
      .each_with_object([], &method(:group_by_course_lines))
      .reject(&method(:pruned_courses))
      .each(&method(:build_course))
  end

  private

  def group_by_course_lines(parsed_line, memo)
    if parsed_line.type?(:course)
      add_to memo, parsed_line
    else
      memo.last << parsed_line
    end
  end

  def add_to(memo, parsed_line)
    existing_index = memo.map(&:first).map(&:course).map(&:code).find_index(parsed_line.course.code)

    memo << if existing_index.nil?
              [parsed_line]
            else
              memo.delete_at(existing_index)
            end
  end

  def pruned_courses(parsed_lines)
    SKIP_COURSES.include?(parsed_lines[0].course.code)
  end

  def build_course(parsed_lines)
    course = Course.where(code: parsed_lines[0].course.code).first_or_create!
    academic_degree_term_course = @academic_degree_term.academic_degree_term_courses.build(course: course)

    EtsPdf::Etl::GroupBuilder.call(academic_degree_term_course, parsed_lines[1..])

    academic_degree_term_course.save!
  end
end
