# frozen_string_literal: true

require "rails_helper"

describe Group do
  subject(:group) { described_class.new }

  it do
    expect(group).to find_or_initialize_for_serialized(:periods, attributes: { type: "TP",
                                                                               starts_at: 100,
                                                                               ends_at: 1000 })
  end

  it { is_expected.to have_attr_accessor(:number) }
  it { is_expected.to have_attr_accessor(:periods) }

  it { is_expected.to delegate_method(:empty?).to(:periods) }

  describe "#new" do
    context "when passing in attributes" do
      subject { described_class.new(number: 1, periods: periods) }

      let(:periods) { [double, double] }

      its(:number) { is_expected.to eq(1) }
      its(:periods) { is_expected.to eq(periods) }
    end
  end

  describe "#overlaps?" do
    context "when no periods overlap" do
      subject(:group) do
        described_class.new(
          number: 1,
          periods: [
            Period.new(type: "TP", starts_at: 0, ends_at: 1000),
            Period.new(type: "C", starts_at: 1500, ends_at: 3000)
          ]
        )
      end

      let(:other) do
        described_class.new(
          number: 2,
          periods: [
            Period.new(type: "TP", starts_at: 4000, ends_at: 5000),
            Period.new(type: "C", starts_at: 6000, ends_at: 7000)
          ]
        )
      end

      specify { expect(group.overlaps?(other)).to be(false) }
    end

    context "when periods overlap" do
      subject(:group) do
        described_class.new(
          number: 1,
          periods: [
            Period.new(type: "TP", starts_at: 0, ends_at: 1000),
            Period.new(type: "C", starts_at: 1500, ends_at: 3000)
          ]
        )
      end

      let(:other) do
        described_class.new(
          number: 2,
          periods: [
            Period.new(type: "TP", starts_at: 4000, ends_at: 5000),
            Period.new(type: "C", starts_at: 0, ends_at: 7000)
          ]
        )
      end

      specify { expect(group.overlaps?(other)).to be(true) }
    end
  end

  describe "#==" do
    subject(:group) { described_class.new(number: 1, periods: periods) }

    let(:periods) { [double] }

    it "returns false if numbers do not match" do
      expect(described_class.new(number: 1)).not_to eq(described_class.new(number: 2))
    end

    it "returns false if periods do not match" do
      expect(described_class.new(periods: [double])).not_to eq(described_class.new({}))
    end

    it "returns true if everything matches" do
      expect(group).to eq(described_class.new(number: 1, periods: periods))
    end
  end
end
