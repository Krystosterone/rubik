# frozen_string_literal: true
require "rails_helper"

describe ScheduleGenerator do
  describe "#combine" do
    ScheduleGeneratorTestCase.all.each do |schedule_generator_case|
      context "for agenda #{schedule_generator_case[:agenda_attributes][:token]}" do
        subject(:generator) { described_class.new(agenda) }

        let(:expected_course_groups) { schedule_generator_case[:generated_course_groups] }
        let(:actual_course_groups) { agenda.schedules.collect(&:course_groups) }

        let(:academic_degree_term) { create(:academic_degree_term) }
        let(:agenda_attributes) do
          schedule_generator_case[:agenda_attributes].merge(academic_degree_term: academic_degree_term)
        end
        let(:agenda) { Agenda.create!(agenda_attributes) }

        before do
          schedule_generator_case[:academic_degree_term_courses_attributes].each do |attributes|
            AcademicDegreeTermCourse.create!(
              academic_degree_term: academic_degree_term,
              id: attributes[:id],
              course: Course.new(code: attributes.dig(:course_attributes, :code)),
              groups: attributes[:groups]
            )
          end

          generator.combine
        end

        it "combines all schedules appropriately" do
          expect(actual_course_groups).to eq(expected_course_groups)
        end
      end
    end
  end
end
