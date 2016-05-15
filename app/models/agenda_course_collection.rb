class AgendaCourseCollection < Array
  def initialize(courses, mandatory_course_codes, leaves)
    super courses
    @mandatory_course_codes = mandatory_course_codes
    @leaves = leaves
  end

  def mandatory
    collection(mandatory_courses)
  end

  def pruned
    collection(pruned_courses)
  end

  private

  alias courses to_a

  def cloned_courses
    AgendaCoursesSerializer.load_as_json(AgendaCoursesSerializer.dump_as_json(courses))
  end

  def mandatory_courses
    @mandatory_course_codes.collect do |mandatory_course_code|
      cloned_courses.find { |course| course.code.casecmp(mandatory_course_code) }
    end
  end

  def pruned_courses
    cloned_courses.each(&method(:prune_courses)).reject(&:empty?)
  end

  def prune_courses(course)
    course.groups.reject!(&method(:overlaps_leaves?))
  end

  def overlaps_leaves?(group)
    @leaves.any? do |leave|
      group.periods.any? { |period| leave.overlaps?(period) }
    end
  end

  def collection(courses)
    AgendaCourseCollection.new(courses, @mandatory_course_codes, @leaves)
  end
end
