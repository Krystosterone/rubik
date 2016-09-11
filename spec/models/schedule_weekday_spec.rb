# frozen_string_literal: true
require "rails_helper"

describe ScheduleWeekday do
  it { is_expected.to delegate_method(:empty?).to(:periods) }

  describe "#new" do
    context "when passing in some attributes" do
      subject { described_class.new(index: 6, periods: periods) }
      let(:periods) { [instance_double(Period), instance_double(Period)] }

      its(:index) { is_expected.to eq(6) }
      its(:periods) { is_expected.to eq(periods) }
    end
  end

  context "for periods with a minimum starting time at 200 and ending at 800" do
    subject { described_class.new(periods: periods) }
    let(:periods) do
      [
        instance_double(Period, starts_at: 300, ends_at: 500),
        instance_double(Period, starts_at: 200, ends_at: 400),
        instance_double(Period, starts_at: 400, ends_at: 700),
        instance_double(Period, starts_at: 600, ends_at: 800),
      ]
    end

    its(:starts_at) { is_expected.to eq(200) }
    its(:ends_at) { is_expected.to eq(800) }
  end

  describe "#weekend?" do
    { [0, 6] => true,
      (1..5) => false }.each do |indexes, is_weekend|
      indexes.each do |index|
        context "for index #{index}" do
          subject(:schedule_weekday) { described_class.new(index: index) }

          it "returns #{is_weekend}" do
            expect(schedule_weekday.weekend?).to eq(is_weekend)
          end
        end
      end
    end
  end

  describe "#==" do
    subject(:schedule_weekday) { described_class.new(index: 3, periods: periods) }
    let(:periods) { [instance_double(Period), instance_double(Period)] }

    context "for non matching instances" do
      specify { expect(schedule_weekday).not_to eq(described_class.new) }
    end

    context "for matching instances" do
      specify { expect(schedule_weekday).to eq(described_class.new(index: 3, periods: periods)) }
    end
  end
end
