# frozen_string_literal: true

require "rails_helper"

describe Agenda::Validator do
  subject(:validator) { described_class.new }

  let(:agenda) { build(:agenda) }

  describe "#validate" do
    it "validates courses" do
      agenda.courses { |course| allow(course).to receive(:validate) }
      validator.validate(agenda)
    end

    context "with a record that has no error" do
      it "does not add an error on the record" do
        expect { validator.validate(agenda) }
          .not_to(change { agenda.errors.added?(:courses) })
      end
    end

    context "with a record that has no courses per schedule" do
      before { agenda.assign_attributes(courses_per_schedule: nil) }

      it "does not add an error on the record" do
        expect { validator.validate(agenda) }.not_to(change { agenda.errors.added?(:courses) })
      end
    end

    context "with a record that has no courses" do
      before { agenda.assign_attributes(courses: []) }

      it "adds and error on the record" do
        expect { validator.validate(agenda) }.to change { agenda.errors.added?(:courses, :blank) }.to(true)
      end
    end

    context "with a record has more courses per schedule than courses" do
      before { agenda.assign_attributes(courses: build_list(:agenda_course, 2), courses_per_schedule: 4) }

      it "adds and error on the record" do
        expect { validator.validate(agenda) }
          .to change { agenda.errors.added?(:courses, :greater_than_or_equal_to_courses_per_schedule) }.to(true)
      end
    end

    context "with the number of mandatory courses being more than the number of selected courses" do
      before do
        agenda.assign_attributes(
          courses: build_list(:mandatory_agenda_course, 3) + [build(:agenda_course)],
          courses_per_schedule: 2
        )
      end

      let(:error_code) { :mandatory_courses_less_than_or_equal_to_courses_per_schedule }

      it "adds and error on the record" do
        expect { validator.validate(agenda) }.to change { agenda.errors.added?(:courses, error_code) }.to(true)
      end
    end

    context "when there are some courses selected when not necessary" do
      before do
        agenda.assign_attributes(
          courses: build_list(:mandatory_agenda_course, 3) + [build(:agenda_course)],
          courses_per_schedule: 3
        )
      end

      it "adds and error on the record" do
        expect { validator.validate(agenda) }
          .to change { agenda.errors.added?(:courses, :mandatory_courses_redundant) }.to(true)
      end
    end

    context "when any leave is invalid" do
      before do
        agenda.assign_attributes(leaves: [
          Leave.new(starts_at: 2000, ends_at: 1000),
          Leave.new(starts_at: 2000, ends_at: 1000),
        ])
        agenda.valid?
      end

      it "sets the agenda to be invalid" do
        expect(agenda).not_to be_valid
      end

      it "adds an error on agenda" do
        expect(agenda.errors).to be_added(:leaves, :invalid)
      end

      it "sets an error on leaves" do
        expect(agenda.leaves.all?(&:invalid?)).to be(true)
      end
    end

    context "when all leaves are valid" do
      before { agenda.valid? }

      it "adds no errors on leaves" do
        expect(agenda.errors).not_to be_added(:leaves, :invalid)
      end
    end
  end
end
