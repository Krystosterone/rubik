# frozen_string_literal: true
require "rails_helper"

describe GroupDecorator do
  subject(:decorator) { described_class.new(group) }
  let(:group) { build(:group) }

  describe "#periods" do
    specify { expect(decorator.periods).to be_decorated }
    specify { expect(decorator.periods).to eq(group.periods) }
  end
end
