require 'rails_helper'

describe Group do

  it do
    is_expected.to find_or_initialize_for_serialized(:periods, attributes: { type: 'TP',
                                                                             starts_at: 100,
                                                                             ends_at: 1000 })
  end
  it { is_expected.to have_attr_accessor(:number) }
  it { is_expected.to have_attr_accessor(:periods) }

  describe '#new' do
    context 'when passing in attributes' do
      let(:periods) { [double, double] }
      subject { described_class.new(number: 1, periods: periods) }

      its(:number) { is_expected.to eq(1) }
      its(:periods) { is_expected.to eq(periods) }
    end
  end

  describe '#overlaps?' do
    context 'when no periods overlap' do
      subject do
        described_class.new(
          number: 1,
          periods: [
            Period.new(type: 'TP', starts_at: 0, ends_at: 1000),
            Period.new(type: 'C', starts_at: 1500, ends_at: 3000)
          ]
        )
      end
      let(:other) do
        described_class.new(
          number: 2,
          periods: [
            Period.new(type: 'TP', starts_at: 4000, ends_at: 5000),
            Period.new(type: 'C', starts_at: 6000, ends_at: 7000)
          ]
        )
      end

      specify { expect(subject.overlaps?(other)).to eq(false) }
    end

    context 'when periods overlap' do
      subject do
        described_class.new(
          number: 1,
          periods: [
            Period.new(type: 'TP', starts_at: 0, ends_at: 1000),
            Period.new(type: 'C', starts_at: 1500, ends_at: 3000)
          ]
        )
      end
      let(:other) do
        described_class.new(
          number: 2,
          periods: [
            Period.new(type: 'TP', starts_at: 4000, ends_at: 5000),
            Period.new(type: 'C', starts_at: 0, ends_at: 7000)
          ]
        )
      end

      specify { expect(subject.overlaps?(other)).to eq(true) }
    end
  end

  describe '#==' do
    let(:periods) { [double] }

    it 'returns false if periods do not match' do
      expect(described_class.new(periods: [double]))
        .not_to eq(described_class.new([]))
    end

    it 'returns true if periods match' do
      expect(described_class.new(periods: periods))
        .to eq(described_class.new(periods: periods))
    end
  end
end
