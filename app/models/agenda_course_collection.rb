class AgendaCourseCollection < Array
  def initialize(courses, mandatory_course_ids, leaves)
    super courses
    @mandatory_course_ids = mandatory_course_ids
    @leaves = leaves
  end

  def mandatory
    collection(mandatory_courses)
  end

  def remainder
    collection(remainder_courses)
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
    cloned_courses.select(&method(:mandatory?))
  end

  def remainder_courses
    cloned_courses.reject(&method(:mandatory?))
  end

  def mandatory?(course)
    @mandatory_course_ids.any? { |mandatory_course_id| mandatory_course_id == course.id }
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
    AgendaCourseCollection.new(courses, @mandatory_course_ids, @leaves)
  end
end
