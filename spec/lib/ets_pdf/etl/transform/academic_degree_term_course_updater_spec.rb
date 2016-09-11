# frozen_string_literal: true
require "rails_helper"

describe EtsPdf::Etl::Transform::AcademicDegreeTermCourseUpdater do
  describe "#execute" do
    subject(:updater) { described_class.new(academic_degree_term, course_data) }
    let(:academic_degree_term) { create(:academic_degree_term) }
    let(:course_data) { instance_double(EtsPdf::Parser::ParsedLine::Course, code: "LOG120") }
    let(:course) { Course.find_by(code: "LOG120") }

    context "when no courses have been created" do
      it "creates the course" do
        updater.execute

        expect(course).to be_present
      end

      it "initializes the academic degree term course" do
        academic_degree_term_course = updater.execute
        expect(academic_degree_term_course.course).to eq(course)
      end
    end

    context "when courses exist" do
      let!(:course) { Course.create!(code: "LOG120") }
      let!(:academic_degree_term_course) do
        academic_degree_term.academic_degree_term_courses.create!(course: course)
      end

      it "does not add a new course" do
        expect { updater.execute }.not_to change { Course.count }
      end

      it "retrieves the existing academic degree term course" do
        expect(updater.execute).to eq(academic_degree_term_course)
      end
    end
  end
end
