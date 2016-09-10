require "rails_helper"

describe ScheduleWeekday do
  it { is_expected.to delegate_method(:empty?).to(:periods) }

  describe "#new" do
    context "when passing in some attributes" do
      let(:periods) { [double, double] }
      subject { described_class.new(index: 6, periods: periods) }

      its(:index) { is_expected.to eq(6) }
      its(:periods) { is_expected.to eq(periods) }
    end
  end

  context "for periods with a minimum starting time at 200 and ending at 800" do
    let(:periods) do
      [double(starts_at: 300, ends_at: 500),
       double(starts_at: 200, ends_at: 400),
       double(starts_at: 400, ends_at: 700),
       double(starts_at: 600, ends_at: 800),]
    end
    subject { described_class.new(periods: periods) }

    its(:starts_at) { is_expected.to eq(200) }
    its(:ends_at) { is_expected.to eq(800) }
  end

  describe "#weekend?" do
    { [0, 6] => true,
      (1..5) => false }.each do |indexes, is_weekend|
      indexes.each do |index|
        context "for index #{index}" do
          subject { described_class.new(index: index) }

          it "returns #{is_weekend}" do
            expect(subject.weekend?).to eq(is_weekend)
          end
        end
      end
    end
  end

  describe "#==" do
    let(:periods) { [double(Period), double(Period)] }
    subject { described_class.new(index: 3, periods: periods) }

    context "for non matching instances" do
      specify { expect(subject).not_to eq(described_class.new) }
    end

    context "for matching instances" do
      specify { expect(subject).to eq(described_class.new(index: 3, periods: periods)) }
    end
  end
end
