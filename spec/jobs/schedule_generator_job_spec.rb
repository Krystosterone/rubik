require "rails_helper"

describe ScheduleGeneratorJob do
  describe "#perform" do
    let(:agenda) { create(:combined_agenda) }
    let(:schedule_generator) { double(ScheduleGenerator) }
    before do
      Timecop.freeze(2016, 1, 1)
      allow(ScheduleGenerator).to receive(:new).with(agenda).and_return(schedule_generator)
    end
    after { Timecop.return }

    it "deletes all previous schedules and generates new schedules for the agenda" do
      expect(schedule_generator).to receive(:combine)
      expect(agenda).to receive(:save!)

      subject.perform(agenda)

      expect(agenda.schedules).to be_empty
      expect(agenda).not_to be_processing
      expect(agenda.combined_at).to eq(Time.zone.now)
    end
  end
end
