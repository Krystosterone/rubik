# frozen_string_literal: true

shared_examples "WeekdayTime" do
  context "with 200 minutes" do
    subject(:time) { described_class.new(200) }

    its(:total_minutes) { is_expected.to eq(200) }
    it { is_expected.to delegate_method(:to_s).to(:total_minutes) }

    describe "#to_i" do
      it "returns #total_minutes" do
        expect(time.to_i).to eq(200)
      end
    end

    its(:hour) { is_expected.to eq(3) }
    its(:minutes) { is_expected.to eq(20) }
  end

  describe "#==" do
    subject(:time) { described_class.new(550) }

    context "when both do not match" do
      it "returns false" do
        expect(time).not_to eq(described_class.new(20))
      end
    end

    context "when both match" do
      it "is true" do
        expect(time).to eq(described_class.new(550))
      end
    end
  end
end
