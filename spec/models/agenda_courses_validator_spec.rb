require "rails_helper"

describe AgendaCoursesValidator do
  subject(:validator) { described_class.new }

  describe "#validate" do
    context "with a record that has no error" do
      let(:agenda) { Agenda.new(courses: [AgendaCourse.new, AgendaCourse.new], courses_per_schedule: 2) }

      it "does not add an error on the record" do
        expect { validator.validate(agenda) }
          .not_to change { agenda.errors.added?(:courses) }
      end
    end

    context "with a record that has no courses" do
      let(:agenda) { Agenda.new }

      it "adds and error on the record" do
        expect { validator.validate(agenda) }.to change { agenda.errors.added?(:courses, :blank) }.to(true)
      end
    end

    context "with a record has more courses per schedule than courses" do
      let(:agenda) { Agenda.new(courses: [AgendaCourse.new, AgendaCourse.new], courses_per_schedule: 4) }

      it "adds and error on the record" do
        expect { validator.validate(agenda) }
          .to change { agenda.errors.added?(:courses, :greater_than_or_equal_to_courses_per_schedule) }.to(true)
      end
    end

    context "with the number of mandatory courses being more than the number of selected courses" do
      let(:agenda) do
        Agenda.new(
          courses: [
            AgendaCourse.new(id: 1),
            AgendaCourse.new(id: 2),
            AgendaCourse.new(id: 3),
            AgendaCourse.new(id: 4),
          ],
          courses_per_schedule: 2,
          mandatory_course_ids: [1, 2, 3]
        )
      end

      it "adds and error on the record" do
        error_code = :less_than_or_equal_to_courses_per_schedule
        expect { validator.validate(agenda) }
          .to change { agenda.errors.added?(:mandatory_course_ids, error_code) }.to(true)
      end
    end

    context "when there are some courses selected when not necessary" do
      let(:agenda) do
        Agenda.new(
          courses: [
            AgendaCourse.new(id: 1),
            AgendaCourse.new(id: 2),
            AgendaCourse.new(id: 3),
            AgendaCourse.new(id: 4),
          ],
          courses_per_schedule: 3,
          mandatory_course_ids: [1, 2, 3]
        )
      end

      it "adds and error on the record" do
        expect { validator.validate(agenda) }
          .to change { agenda.errors.added?(:mandatory_course_ids, :redundant) }.to(true)
      end
    end
  end
end
