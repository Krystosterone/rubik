namespace :schedule_generator_case do
  task write: :environment do
    schedule_generator_case = ScheduleGeneratorTestCase.new(ENV.fetch("AGENDA_TOKEN"))
    schedule_generator_case.write
  end
end
