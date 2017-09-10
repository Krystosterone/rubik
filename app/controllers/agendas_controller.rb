# frozen_string_literal: true
class AgendasController < ApplicationController
  include AgendaEagerLoading
  include AgendasHelper
  include BrowserCaching

  before_action :invalidate_browser_cache
  before_action :find_agenda,
                :ensure_not_processing, only: [:edit, :update]
  before_action :instantiate_agenda, only: [:new, :create]
  before_action :assign_academic_degree_terms, if: :first_step?
  before_action :assign_first_step_attributes, only: [:create, :update], if: :first_step?
  before_action :eager_load_courses, unless: :first_step?
  before_action :assign_attributes, only: [:create, :update]
  before_action :save, only: [:create, :update]

  delegate :step, to: :agenda_creation_process
  helper_method :step

  def new
    render step
  end

  def edit
    render step
  end

  def create; end

  def update; end

  private

  def agenda_params
    params.require(:agenda).permit(
      :courses_per_schedule,
      :filter_groups,
      courses_attributes: [:_destroy, :academic_degree_term_course_id, :id, :mandatory, { group_numbers: [] }],
      leaves_attributes: [:_destroy, :ends_at, :starts_at]
    )
  end

  def agenda_token
    params.require(:token)
  end

  def assign_attributes
    @agenda.assign_attributes(agenda_params)
  end

  def agenda_creation_process
    @agenda_creation_process ||= AgendaCreationProcess.new(agenda: @agenda, step: params[:step])
  end

  def save
    agenda_creation_process.save ? redirect_to(agenda_creation_process.path) : render(step)
  end

  def ensure_not_processing
    redirect_to(processing_agenda_schedules_path(@agenda)) if @agenda.processing?
  end

  def instantiate_agenda
    @agenda = Agenda.new
  end

  def assign_academic_degree_terms
    @academic_degree_terms =
      AcademicDegreeTerm
        .enabled
        .includes(:academic_degree, :term)
        .where(
          terms: {
            name: agenda_term_name(@agenda),
            year: agenda_term_year(@agenda),
          },
        )
  end

  def term_params
    params.slice(:term_name, :term_year).permit!.to_h
  end

  def first_step?
    step == AgendaCreationProcess::STEP_FILTER_SELECTION
  end

  def assign_first_step_attributes
    agenda_term_tags_attributes =
      params
        .fetch(:agenda, {})
        .fetch(:agenda_term_tags_attributes, {})
        .permit!
        .to_h
        .map { |_, value| value[:term_tag_id] }
        .compact
        .map { |value| Base64.decode64(value) }
        .map { |value| value.split("\;") }
        .map { |value| value.map { |attribute| attribute.split(":") } }
        .map { |value| value.to_h.with_indifferent_access }
        .each_with_object({}) { |value, memo| memo[value[:scope]] = value[:value] }
        .with_indifferent_access

    academic_degree_term_attributes =
      term_params
        .each_with_object({}) { |(key, value), memo| memo[key.to_s.sub("term_", "")] = value }

    academic_degree_attributes = { code: agenda_term_tags_attributes[:academic_degree] }
    term_attributes = academic_degree_term_attributes.merge(tags: agenda_term_tags_attributes[:term])

    term = Term.where(term_attributes).first
    academic_degree = AcademicDegree.where(academic_degree_attributes).first
    @agenda.assign_academic_degree_term(academic_degree: academic_degree, term: term)

    render(step) if @agenda.errors.present?
  end
end
