# frozen_string_literal: true

require "rails_helper"

describe EtsPdf::Etl::GroupBuilder do
  describe ".call" do
    let(:academic_degree_term_course) { build(:academic_degree_term_course) }
    let(:group1) { academic_degree_term_course.groups.find { |group| group.number == 1 } }
    let(:group2) { academic_degree_term_course.groups.find { |group| group.number == 2 } }
    let(:group3) { academic_degree_term_course.groups.find { |group| group.number == 3 } }
    let(:parsed_lines) do
      [
        build(:parsed_group_line, number: "01"),
        build(:parsed_period_line),
        build(:parsed_period_line),

        build(:parsed_group_line, number: "02"),
        build(:parsed_period_line),

        build(:parsed_group_line, number: "03"),
        build(:parsed_period_line),
      ]
    end

    before { allow(EtsPdf::Etl::PeriodBuilder).to receive(:call) }

    it "calls the period builder with the first collection of group and periods" do
      described_class.call(academic_degree_term_course, parsed_lines)

      expect(EtsPdf::Etl::PeriodBuilder).to have_received(:call).with(group1, parsed_lines[0..2])
    end

    it "calls the period builder with the second collection of group and periods" do
      described_class.call(academic_degree_term_course, parsed_lines)

      expect(EtsPdf::Etl::PeriodBuilder).to have_received(:call).with(group2, parsed_lines[3..4])
    end

    it "calls the period builder with the last collection of group and periods" do
      described_class.call(academic_degree_term_course, parsed_lines)

      expect(EtsPdf::Etl::PeriodBuilder).to have_received(:call).with(group3, parsed_lines[5..6])
    end
  end
end
