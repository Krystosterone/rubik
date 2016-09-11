# frozen_string_literal: true
require "rails_helper"

describe SerializedRecord::FindOrInitializeFor do
  subject { TestProfessor.new }

  it { is_expected.to find_or_initialize_for_serialized(:test_students, attributes: { name: "Bob" }) }
end
