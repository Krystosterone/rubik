class ScheduleGeneratorJob < ActiveJob::Base
  def perform(agenda)
    ActiveRecord::Base.transaction do
      agenda.schedules.destroy_all
      ScheduleGenerator.new(agenda).combine
      agenda.save!
    end
  end
end
