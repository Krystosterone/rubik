require 'rails_helper'

describe ScheduleGenerator do
  fixtures :agendas, :schedules

  describe '#combine' do
    Agenda.all.each do |agenda|
      context "for agenda #{agenda.id}" do
        let!(:expected_course_groups) { agenda.schedules.collect(&:course_groups) }
        let(:actual_course_groups) { agenda.schedules.collect(&:course_groups) }
        subject { described_class.new(agenda) }
        before do
          agenda.schedules = []
          subject.combine
        end

        it 'combines all schedules' do
          expect(actual_course_groups).to match_array(expected_course_groups)
        end
      end
    end
  end
end
