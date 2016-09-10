require "rails_helper"

describe EtsPdf::Etl::Transform::AcademicDegreeTermCourseUpdater do
  describe "#execute" do
    let(:academic_degree_term) { create(:academic_degree_term) }
    let(:course_data) { double(EtsPdf::Parser::ParsedLine::Course, code: "LOG120") }
    let(:course) { Course.find_by(code: "LOG120") }
    subject { described_class.new(academic_degree_term, course_data) }

    context "when no courses have been created" do
      it "creates the course" do
        subject.execute

        expect(course).to be_present
      end

      it "initializes the academic degree term course" do
        academic_degree_term_course = subject.execute
        expect(academic_degree_term_course.course).to eq(course)
      end
    end

    context "when courses exist" do
      let!(:course) { Course.create!(code: "LOG120") }
      let!(:academic_degree_term_course) do
        academic_degree_term.academic_degree_term_courses.create!(course: course)
      end

      it "does not add a new course" do
        expect { subject.execute }.not_to change { Course.count }
      end

      it "retrieves the existing academic degree term course" do
        expect(subject.execute).to eq(academic_degree_term_course)
      end
    end
  end
end
