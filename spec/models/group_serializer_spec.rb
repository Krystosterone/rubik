require "rails_helper"

describe GroupSerializer do
  group = Group.new(number: 1,
                    periods: [Period.new(type: "Labo",
                                         starts_at: 0,
                                         ends_at: 100)])
  serialized = [1, [["Labo", 0, 100]]]

  it_behaves_like "Serializer", data_structure: group, as_json: serialized
end
