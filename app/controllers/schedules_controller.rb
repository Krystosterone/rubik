class SchedulesController < ApplicationController
  layout "processing", only: :processing

  before_action :find_agenda
  before_action :ensure_schedules_present, only: :index
  before_action :ensure_processing, only: :processing

  decorates_assigned :agenda
  decorates_assigned :schedules

  def index
    @schedules = @agenda.schedules.page(params[:page]).per(ScheduleHelper::SCHEDULES_PER_PAGE)
  end

  def processing
  end

  private

  def find_agenda
    @agenda = Agenda.find_by!(token: agenda_token)
  end

  def agenda_token
    params.require(:agenda_token)
  end

  def ensure_schedules_present
    if @agenda.processing?
      redirect_to action: :processing
    elsif @agenda.empty?
      redirect_to edit_agenda_path(token: @agenda.token), flash: { notice: t(".blank_agenda") }
    end
  end

  def ensure_processing
    redirect_to action: :index unless @agenda.processing?
  end
end
