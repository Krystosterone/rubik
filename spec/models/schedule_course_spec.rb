# frozen_string_literal: true

require "rails_helper"

describe ScheduleCourse do
  it_behaves_like "WeekdayTimeRange"

  describe "#new" do
    context "when passing in some attributes" do
      subject { described_class.new(index: 3, code: "LOG320", number: 1, type: "TP") }

      its(:index) { is_expected.to eq(3) }
      its(:code) { is_expected.to eq("LOG320") }
      its(:number) { is_expected.to eq(1) }
      its(:type) { is_expected.to eq("TP") }
    end
  end

  describe "#==" do
    subject(:schedule_course) { described_class.new(index: 3, code: "LOG320", number: 1, type: "TP") }

    context "when instances do not match" do
      specify { expect(schedule_course).not_to eq(described_class.new) }
    end

    context "when instance do match" do
      let(:other) { described_class.new(index: 3, code: "LOG320", number: 1, type: "TP") }

      specify { expect(schedule_course).to eq(other) }
    end
  end
end
