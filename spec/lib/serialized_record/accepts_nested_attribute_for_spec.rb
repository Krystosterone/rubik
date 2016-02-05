require "rails_helper"

describe SerializedRecord::AcceptsNestedAttributeFor do
  subject { TestProfessor.new }

  it { is_expected.to accept_nested_attributes_for_serialized(:test_students, attributes: { name: "Bob" }) }
end
