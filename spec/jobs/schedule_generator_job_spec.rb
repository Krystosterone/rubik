require 'rails_helper'

describe ScheduleGeneratorJob do
  describe '#perform' do
    let(:agenda) { double(Agenda) }
    let(:schedule_generator) { double(ScheduleGenerator) }
    before { allow(ScheduleGenerator).to receive(:new).with(agenda).and_return(schedule_generator) }

    it 'generates schedules for the agenda' do
      expect(schedule_generator).to receive(:combine)
      expect(agenda).to receive(:save!)

      subject.perform(agenda)
    end
  end
end
