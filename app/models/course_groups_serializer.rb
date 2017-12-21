# frozen_string_literal: true

class CourseGroupsSerializer < Serializer
  class << self
    def dump_as_json(course_groups)
      course_groups.collect do |course_group|
        serialized_group = GroupSerializer.dump_as_json(course_group.group)
        [course_group.code, serialized_group]
      end
    end

    def load_as_json(serialized_course_groups)
      serialized_course_groups.collect do |serialized_course_group|
        group = GroupSerializer.load_as_json(serialized_course_group[1])
        CourseGroup.new(code: serialized_course_group[0], group: group)
      end
    end
  end
end
