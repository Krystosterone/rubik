class ScheduleGeneratorJob < ActiveJob::Base
  def perform(agenda)
    agenda.schedules.destroy_all
    ScheduleGenerator.new(agenda).combine
    agenda.save!
  end
end
