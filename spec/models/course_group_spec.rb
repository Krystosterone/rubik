require 'rails_helper'

describe CourseGroup do
  let(:group) { double }

  it { is_expected.to have_attr_accessor(:code) }
  it { is_expected.to have_attr_accessor(:group) }

  it { is_expected.to delegate_method(:number).to(:group) }
  it { is_expected.to delegate_method(:periods).to(:group) }
  it { is_expected.to delegate_method(:overlaps?).to(:group) }

  describe '#new' do
    context 'with attributes passed in' do
      subject { described_class.new(code: 'CODE', group: group) }

      its(:code) { is_expected.to eq('CODE') }
      its(:group) { is_expected.to eq(group) }
    end
  end

  describe '#==' do
    it 'returns false if course groups do not match' do
      expect(described_class.new(code: nil, group: nil))
        .not_to eq(described_class.new(code: 'CODE', group: group))
    end

    it 'returns true if course groups match' do
      expect(described_class.new(code: 'CODE', group: group))
        .to eq(described_class.new(code: 'CODE', group: group))
    end
  end
end
