# frozen_string_literal: true
namespace :schedule_generator_case do
  task write: :environment do
    ENV.fetch("AGENDA_TOKEN").split(",").each do |token|
      schedule_generator_case = ScheduleGeneratorTestCase.new(token)
      schedule_generator_case.write
    end
  end
end
