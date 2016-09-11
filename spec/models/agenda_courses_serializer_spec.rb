# frozen_string_literal: true
require "rails_helper"

describe AgendaCoursesSerializer do
  courses = [AgendaCourse.new(id: 3,
                              code: "A_CODE",
                              groups: [Group.new(number: 1,
                                                 periods: [Period.new(type: "Labo",
                                                                      starts_at: 0,
                                                                      ends_at: 100)])])]
  serialized = [[3, "A_CODE", [[1, [["Labo", 0, 100]]]]]]

  it_behaves_like "Serializer", data_structure: courses, as_json: serialized
end
