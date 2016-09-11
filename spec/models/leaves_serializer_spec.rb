# frozen_string_literal: true
require "rails_helper"

describe LeavesSerializer do
  leaves = [Leave.new(starts_at: 0, ends_at: 100),
            Leave.new(starts_at: 567, ends_at: 5678)]
  serialized = [[0, 100], [567, 5678]]

  it_behaves_like "Serializer", data_structure: leaves, as_json: serialized
end
