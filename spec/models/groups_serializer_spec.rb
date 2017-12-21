# frozen_string_literal: true

require "rails_helper"

describe GroupsSerializer do
  groups = [Group.new(number: 1,
                      periods: [Period.new(type: "Labo",
                                           starts_at: 0,
                                           ends_at: 100)])]
  serialized = [[1, [["Labo", 0, 100]]]]

  it_behaves_like "Serializer", data_structure: groups, as_json: serialized
end
