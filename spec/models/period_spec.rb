# frozen_string_literal: true

require "rails_helper"

describe Period do
  it { is_expected.to have_attr_accessor(:type) }

  describe "#==" do
    subject(:period) { described_class.new(type: "C", starts_at: 0, ends_at: 100) }

    it "returns false if the periods do not match" do
      expect(period).not_to eq(described_class.new(type: "C", starts_at: 0, ends_at: 200))
    end

    it "returns true if the periods match" do
      expect(period).to eq(described_class.new(type: "C", starts_at: 0, ends_at: 100))
    end
  end
end
