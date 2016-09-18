# frozen_string_literal: true
class ScheduleGeneratorJob < ActiveJob::Base
  around_perform { |_job, block| Bullet.profile { block.call } }
  around_perform { |_job, block| ActiveRecord::Base.transaction { block.call } }

  def perform(agenda)
    agenda.schedules.destroy_all
    ScheduleGenerator.new(agenda).combine
    agenda.mark_as_finished_processing
    agenda.save!(validate: false)
  end
end
