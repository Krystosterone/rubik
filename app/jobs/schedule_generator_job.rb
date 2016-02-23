class ScheduleGeneratorJob < ActiveJob::Base
  def perform(agenda)
    ScheduleGenerator.new(agenda).combine
    agenda.save!
  end
end
