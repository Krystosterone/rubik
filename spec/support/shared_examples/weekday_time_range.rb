shared_examples "WeekdayTimeRange" do
  describe "#new" do
    context "with attributes passed in" do
      subject { described_class.new(starts_at: 50, ends_at: 1000) }

      its(:starts_at) { is_expected.to eq(WeekdayTime.new(50)) }
      its(:ends_at) { is_expected.to eq(WeekdayTime.new(1000)) }
    end
  end

  context "when starting at 50 and ending at 1000" do
    subject(:time_range) { described_class.new(starts_at: 50, ends_at: 1000) }

    its(:range) { is_expected.to eq(50...1000) }
    its(:duration) { is_expected.to eq(950) }

    describe "#overlaps?" do
      context "when the ranges do not overlap" do
        let(:result) { time_range.overlaps?(described_class.new(starts_at: 1001, ends_at: 1500)) }

        specify { expect(result).to eq(false) }
      end

      context "when the ranges do overlap" do
        let(:result) { time_range.overlaps?(described_class.new(starts_at: 500, ends_at: 1500)) }

        specify { expect(result).to eq(true) }
      end
    end

    describe "#==" do
      it "returns false if time range does not match" do
        expect(time_range == described_class.new).to eq(false)
      end

      it "returns true if time range matches" do
        other = described_class.new(starts_at: 50, ends_at: 1000)
        expect(time_range == other).to eq(true)
      end
    end
  end

  describe "#empty?" do
    context "when the range has no minutes" do
      subject(:time_range) { described_class.new(starts_at: 0, ends_at: 0) }
      specify { expect(time_range).to be_empty }
    end

    context "when the range has at least a minute" do
      subject(:time_range) { described_class.new(starts_at: 0, ends_at: 1) }
      specify { expect(time_range).not_to be_empty }
    end
  end

  describe "validation on time correctness" do
    context "when the end comes after the start" do
      subject(:time_range) { described_class.new(starts_at: 0, ends_at: 100) }
      before { time_range.valid? }

      it "does not add an error on ends_at" do
        expect(time_range.errors).not_to be_added(:ends_at, :greater_than_or_equal_to_starts_at)
      end
    end

    context "when the start and end are equal" do
      subject(:time_range) { described_class.new(starts_at: 0, ends_at: 0) }
      before { time_range.valid? }

      it "does not add an error on ends_at" do
        expect(time_range.errors).to be_added(:ends_at, :greater_than_or_equal_to_starts_at)
      end
    end

    context "when the end comes before the start" do
      subject(:time_range) { described_class.new(starts_at: 200, ends_at: 100) }
      before { time_range.valid? }

      it "adds an error on ends_at" do
        expect(time_range.errors).to be_added(:ends_at, :greater_than_or_equal_to_starts_at)
      end
    end
  end
end
