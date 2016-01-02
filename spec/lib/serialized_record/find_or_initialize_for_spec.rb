require 'rails_helper'

describe SerializedRecord::FindOrInitializeFor do
  subject { Professor.new }

  it { is_expected.to find_or_initialize_for_serialized(:students, attributes: { name: 'Bob' }) }
end
