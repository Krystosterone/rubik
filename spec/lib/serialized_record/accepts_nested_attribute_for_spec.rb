require 'rails_helper'

describe SerializedRecord::AcceptsNestedAttributeFor do
  subject { Professor.new }

  it { is_expected.to accept_nested_attributes_for_serialized(:students, attributes: { name: 'Bob' }) }
end
