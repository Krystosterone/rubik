class ScheduleGeneratorJob < ActiveJob::Base
  def perform(agenda)
    ActiveRecord::Base.transaction do
      agenda.schedules.destroy_all
      ScheduleGenerator.new(agenda).combine
      agenda.mark_as_finished_processing
      agenda.save!
    end
  end
end
