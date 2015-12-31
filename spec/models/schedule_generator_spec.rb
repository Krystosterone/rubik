require 'rails_helper'

describe ScheduleGenerator do
  describe '#combine' do
    ScheduleGeneratorTestCase.all.each do |schedule_generator_case|
      context "for agenda #{schedule_generator_case[:token]}" do
        let(:expected_course_groups) { schedule_generator_case[:generated_course_groups] }
        let(:actual_course_groups) { agenda.schedules.collect(&:course_groups) }
        let(:agenda) { Agenda.new(schedule_generator_case[:agenda_attributes]) }
        subject { described_class.new(agenda) }
        before { subject.combine }

        it 'combines all schedules appropriately' do
          expect(actual_course_groups).to eq(expected_course_groups)
        end
      end
    end
  end
end
