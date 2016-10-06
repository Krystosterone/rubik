# frozen_string_literal: true
class AgendaCreationProcess
  include Rails.application.routes.url_helpers

  STEPS = [
    :course_selection,
    :group_selection,
  ].freeze
  STEP_COURSE_SELECTION, STEP_GROUP_SELECTION = STEPS

  attr_writer :step

  def initialize(agenda)
    @agenda = agenda
  end

  def path
    last_step? ? processing_agenda_schedules_path(@agenda) : edit_agenda_path(@agenda, step: next_step)
  end

  def save
    last_step? ? combine : @agenda.save
  end

  def step
    (steps & Array(@step).map(&:to_sym)).first || steps.first
  end

  private

  def steps
    @agenda.filter_groups? ? STEPS : Array(STEP_COURSE_SELECTION)
  end

  def next_step
    steps[steps.index(step) + 1]
  end

  def last_step?
    next_step.nil?
  end

  def combine
    @agenda
      .tap(&method(:before_combine))
      .save
      .tap(&method(:after_combine))
  end

  def before_combine(*)
    @agenda.processing = true
    @agenda.combined_at = nil
  end

  def after_combine(save_result)
    if save_result
      ScheduleGeneratorJob.perform_later(@agenda)
    else
      @agenda.restore_attributes([:processing, :combined_at])
    end
  end
end
