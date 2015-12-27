require 'rails_helper'

describe AgendaCoursesValidator do
  describe '#validate' do
    context 'with a record that has no error' do
      let(:agenda) { Agenda.new(courses: [AgendaCourse.new, AgendaCourse.new], courses_per_schedule: 2) }

      it 'does not add an error on the record' do
        expect { subject.validate(agenda) }
          .not_to change { agenda.errors.added?(:courses) }
      end
    end

    context 'with a record that has no courses' do
      let(:agenda) { Agenda.new }

      it 'adds a blank error on the record' do
        expect { subject.validate(agenda) }.to change { agenda.errors.added?(:courses, :blank) }.to(true)
      end
    end

    context 'with a record has more courses per schedule than courses' do
      let(:agenda) { Agenda.new(courses: [AgendaCourse.new, AgendaCourse.new], courses_per_schedule: 4) }

      it 'adds an error on the record' do
        expect { subject.validate(agenda) }
          .to change { agenda.errors.added?(:courses, :greater_than_or_equal_to_courses_per_schedule) }.to(true)
      end
    end
  end
end
