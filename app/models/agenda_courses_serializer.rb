# frozen_string_literal: true
class AgendaCoursesSerializer < Serializer
  class << self
    def dump_as_json(courses)
      courses.collect do |course|
        serialized_groups = GroupsSerializer.dump_as_json(course.groups)
        [course.id, course.code, serialized_groups]
      end
    end

    def load_as_json(serialized_courses)
      serialized_courses.collect do |serialized_course|
        groups = GroupsSerializer.load_as_json(serialized_course[2])
        AgendaCourse.new(id: serialized_course[0],
                         code: serialized_course[1],
                         groups: groups)
      end
    end
  end
end
