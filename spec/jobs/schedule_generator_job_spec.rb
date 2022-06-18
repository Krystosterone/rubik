# frozen_string_literal: true

require "rails_helper"

describe ScheduleGeneratorJob do
  describe "#perform" do
    subject(:job) { described_class.new }

    let(:agenda) { create(:combined_agenda) }
    let(:schedule_generator) { instance_double(ScheduleGenerator) }

    before do
      Timecop.freeze(2016, 1, 1)

      allow(ScheduleGenerator).to receive(:new).with(agenda).and_return(schedule_generator)
      allow(schedule_generator).to receive(:combine)
      allow(agenda).to receive(:save!)

      job.perform(agenda)
    end

    after { Timecop.return }

    specify { expect(agenda.schedules).to be_empty }
    specify { expect(agenda).not_to be_processing }
    specify { expect(agenda.combined_at).to eq(Time.zone.now) }
  end
end
