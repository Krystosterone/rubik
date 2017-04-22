# frozen_string_literal: true
class AgendaCreationProcess
  extend ActiveModel::Callbacks
  include ActiveModel::Model
  include Rails.application.routes.url_helpers

  STEPS = [
    :course_selection,
    :group_selection,
  ].freeze
  STEP_COURSE_SELECTION, STEP_GROUP_SELECTION = STEPS

  define_model_callbacks(*STEPS, only: :before)

  before_course_selection :reset_course_group_numbers

  attr_accessor :agenda
  attr_writer :step

  def path
    last_step? ? processing_agenda_schedules_path(agenda) : edit_agenda_path(agenda, step: next_step)
  end

  def save
    run_callbacks(step) { last_step? ? combine : agenda.save }
  end

  def step
    (steps & Array(@step).map(&:to_sym)).first || steps.first
  end

  private

  def steps
    agenda.filter_groups? ? STEPS : Array(STEP_COURSE_SELECTION)
  end

  def next_step
    steps[steps.index(step) + 1]
  end

  def last_step?
    next_step.nil?
  end

  def combine
    agenda
      .tap(&method(:before_combine))
      .save
      .tap(&method(:after_combine))
  end

  def before_combine(*)
    agenda.processing = true
    agenda.combined_at = nil
  end

  def after_combine(save_result)
    ScheduleGeneratorJob.perform_later(agenda) if save_result
  end

  def reset_course_group_numbers
    agenda.courses.each(&:reset_group_numbers) if agenda.new_record? || !agenda.filter_groups?
  end
end
