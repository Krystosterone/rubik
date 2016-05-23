require "rails_helper"

describe AgendaCoursesValidator do
  describe "#validate" do
    context "with a record that has no error" do
      let(:agenda) { Agenda.new(courses: [AgendaCourse.new, AgendaCourse.new], courses_per_schedule: 2) }

      it "does not add an error on the record" do
        expect { subject.validate(agenda) }
          .not_to change { agenda.errors.added?(:courses) }
      end
    end

    context "with a record that has no courses" do
      let(:agenda) { Agenda.new }

      it "adds and error on the record" do
        expect { subject.validate(agenda) }.to change { agenda.errors.added?(:courses, :blank) }.to(true)
      end
    end

    context "with a record has more courses per schedule than courses" do
      let(:agenda) { Agenda.new(courses: [AgendaCourse.new, AgendaCourse.new], courses_per_schedule: 4) }

      it "adds and error on the record" do
        expect { subject.validate(agenda) }
          .to change { agenda.errors.added?(:courses, :greater_than_or_equal_to_courses_per_schedule) }.to(true)
      end
    end

    context "with the number of mandatory courses being more than the number of selected courses" do
      let(:agenda) do
        Agenda.new(
          courses: [
            AgendaCourse.new(code: "COURSE_1"),
            AgendaCourse.new(code: "COURSE_2"),
            AgendaCourse.new(code: "COURSE_3"),
            AgendaCourse.new(code: "COURSE_4"),
          ],
          courses_per_schedule: 2,
          mandatory_course_codes: %w(COURSE_1 COURSE_2 COURSE_3)
        )
      end

      it "adds and error on the record" do
        error_code = :less_than_or_equal_to_courses_per_schedule
        expect { subject.validate(agenda) }
          .to change { agenda.errors.added?(:mandatory_course_codes, error_code) }.to(true)
      end
    end

    context "when there are some courses selected when not necessary" do
      let(:agenda) do
        Agenda.new(
          courses: [
            AgendaCourse.new(code: "COURSE_1"),
            AgendaCourse.new(code: "COURSE_2"),
            AgendaCourse.new(code: "COURSE_3"),
            AgendaCourse.new(code: "COURSE_4"),
          ],
          courses_per_schedule: 3,
          mandatory_course_codes: %w(COURSE_1 COURSE_2 COURSE_3)
        )
      end

      it "adds and error on the record" do
        expect { subject.validate(agenda) }
          .to change { agenda.errors.added?(:mandatory_course_codes, :redundant) }.to(true)
      end
    end
  end
end
