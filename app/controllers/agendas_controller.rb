class AgendasController < ApplicationController
  before_action :expires_now
  before_action :find_academic_degree_term, only: [:new, :create]
  before_action :find_agenda,
                :ensure_not_processing, only: [:edit, :update]

  decorates_assigned :agenda

  def new
    @agenda = @academic_degree_term.agendas.new
    render :edit
  end

  def edit
  end

  def create
    @agenda = @academic_degree_term.agendas.new(agenda_params)
    combine
  end

  def update
    @agenda.assign_attributes(agenda_params)
    combine
  end

  private

  def find_academic_degree_term
    @academic_degree_term = AcademicDegreeTerm.find(params[:academic_degree_term_id])
  end

  def find_agenda
    @agenda = Agenda.find_by!(token: agenda_token)
  end

  def agenda_params
    params.require(:agenda).permit(:courses_per_schedule,
                                   course_ids: [],
                                   leaves_attributes: [:starts_at, :ends_at, :_destroy])
  end

  def agenda_token
    params.require(:token)
  end

  def combine
    if @agenda.combine
      redirect_to processing_agenda_schedules_path(@agenda)
    else
      render :edit
    end
  end

  def ensure_not_processing
    redirect_to(processing_agenda_schedules_path(@agenda)) if @agenda.processing?
  end
end
