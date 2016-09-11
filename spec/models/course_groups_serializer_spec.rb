# frozen_string_literal: true
require "rails_helper"

describe CourseGroupsSerializer do
  course_groups = [CourseGroup.new(code: "A_CODE",
                                   group: Group.new(number: 1,
                                                    periods: [Period.new(type: "Labo",
                                                                         starts_at: 0,
                                                                         ends_at: 100)]))]
  serialized = [["A_CODE", [1, [["Labo", 0, 100]]]]]

  it_behaves_like "Serializer", data_structure: course_groups, as_json: serialized
end
