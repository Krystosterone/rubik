# frozen_string_literal: true
require "rails_helper"

describe EtsPdf::Etl::AcademicDegreeTermCourseBuilder do
  describe ".call" do
    let(:academic_degree_term) { build(:academic_degree_term) }
    before { academic_degree_term.save! }

    context "with an unparsed line" do
      let(:parsed_lines) { [build(:unparsed_line)] }

      it "does nothing" do
        described_class.call(academic_degree_term, parsed_lines)
      end
    end

    described_class::SKIP_COURSES.each do |course_code|
      context "with a parsed line that has a course code '#{course_code}'" do
        let(:course_line) { build(:parsed_course_line, code: course_code) }
        let(:parsed_lines) { [course_line] }

        it "does nothing" do
          described_class.call(academic_degree_term, parsed_lines)
        end
      end
    end

    context "with groupable parsed lines" do
      let(:academic_degree_term_course_1) do
        academic_degree_term.academic_degree_term_courses.includes(:course).find_by!(courses: { code: "COD001" })
      end
      let(:academic_degree_term_course_2) do
        academic_degree_term.academic_degree_term_courses.includes(:course).find_by!(courses: { code: "COD002" })
      end
      let(:course_1_line) { build(:parsed_course_line, code: "COD001") }
      let(:course_1_lines) do
        [
          course_1_line,
          build(:parsed_group_line),
          build(:parsed_period_line),
          build(:parsed_period_line),
          build(:parsed_group_line),
          build(:parsed_period_line),

          course_1_line,
          build(:parsed_group_line),
          build(:parsed_period_line),
        ]
      end
      let(:course_2_lines) do
        [
          build(:parsed_course_line, code: "COD002"),
          build(:parsed_group_line),
          build(:parsed_period_line),
        ]
      end
      let(:parsed_lines) { course_1_lines + course_2_lines }
      before do
        create(:course, code: "COD001")

        allow(EtsPdf::Etl::GroupBuilder).to receive(:call) do |academic_degree_term_course, _|
          academic_degree_term_course.find_or_initialize_group_by(number: 1)
        end
      end

      it "calls the group builder for the first group of lines" do
        grouped_parsed_lines = course_1_lines[1..5] + course_1_lines[7..-1]

        described_class.call(academic_degree_term, parsed_lines)

        expect(EtsPdf::Etl::GroupBuilder)
          .to have_received(:call).with(academic_degree_term_course_1, grouped_parsed_lines)
      end

      it "calls the group builder for the second group of lines" do
        described_class.call(academic_degree_term, parsed_lines)

        expect(EtsPdf::Etl::GroupBuilder)
          .to have_received(:call).with(academic_degree_term_course_2, course_2_lines[1..-1])
      end
    end
  end
end
