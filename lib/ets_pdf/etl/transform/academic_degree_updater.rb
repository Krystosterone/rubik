class EtsPdf::Etl::Transform::AcademicDegreeUpdater
  SKIP_COURSES = %w(PRE010)

  def initialize(academic_degree_term, lines)
    @academic_degree_term = academic_degree_term
    @lines = lines
  end

  def execute
    @academic_degree_term_course = AcademicDegreeTermCourse.new
    @group = nil
    @lines.each do |parsed_line|
      update(parsed_line) if parsed_line.parsed?
    end
    save_course!
  end

  private

  def update(parsed_line)
    return update_course(parsed_line.course) if parsed_line.type?(:course)
    return update_group(parsed_line.group) if parsed_line.type?(:group)
    update_period(parsed_line.period) if parsed_line.type?(:period)
  end

  def update_course(course_data)
    save_course!
    @academic_degree_term_course =
      EtsPdf::Etl::Transform::AcademicDegreeTermCourseUpdater.new(@academic_degree_term, course_data).execute
    @group = nil
  end

  def update_group(group_data)
    @group = EtsPdf::Etl::Transform::GroupUpdater.new(@academic_degree_term_course, group_data).execute
  end

  def update_period(period_data)
    EtsPdf::Etl::Transform::PeriodUpdater.new(@group, period_data).execute
  end

  def save_course!
    @academic_degree_term_course.save! unless skip_save?
  end

  def skip_save?
    return true if @academic_degree_term_course.groups.empty?
    SKIP_COURSES.include?(@academic_degree_term_course.course.code)
  end
end
