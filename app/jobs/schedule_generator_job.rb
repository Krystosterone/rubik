class ScheduleGeneratorJob < ActiveJob::Base
  def perform(agenda)
    agenda.schedules.delete_all
    ScheduleGenerator.new(agenda).combine
    ActiveRecord::Base.transaction { agenda.save! }
  end
end
