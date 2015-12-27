class ScheduleGeneratorJob < ActiveJob::Base
  def perform(agenda)
    ScheduleGenerator.new(agenda).combine
    ActiveRecord::Base.transaction { agenda.save! }
  end
end
