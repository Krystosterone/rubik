# frozen_string_literal: true

class ScheduleGeneratorJob
  include Sidekiq::Job

  sidekiq_options unique: true

  def perform(agenda_id)
    Bullet.profile do
      ActiveRecord::Base.transaction do
        agenda = Agenda.find(agenda_id)

        agenda.schedules.destroy_all
        ScheduleGenerator.new(agenda).combine
        agenda.mark_as_finished_processing
        agenda.save!(validate: false)
      end
    end
  end
end
