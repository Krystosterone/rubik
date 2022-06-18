# frozen_string_literal: true

require "rails_helper"

describe "schedule_generator_case:write", type: :feature do
  let(:schedule_generator_test_case) { instance_double(ScheduleGeneratorTestCase) }

  before do
    ENV["AGENDA_TOKEN"] = "an_agenda_token"
    allow(ScheduleGeneratorTestCase).to receive(:new).with("an_agenda_token").and_return(schedule_generator_test_case)
  end

  after { ENV.delete("AGENDA_TOKEN") }

  it "writes a schedule generator case to file" do
    allow(schedule_generator_test_case).to receive(:write)

    rake_task.execute
  end
end
