class SchedulesController < ApplicationController
  before_action :find_agenda
  before_action :ensure_not_processing,
                :ensure_schedules_present, only: :index
  before_action :ensure_processing, only: :processing
  skip_before_action :show_navigation, only: :processing

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
    redirect_to edit_agenda_path(token: @agenda.token), flash: { notice: t(".blank_agenda") } if @agenda.empty?
  end

  def ensure_not_processing
    redirect_to action: :processing if @agenda.processing?
  end

  def ensure_processing
    redirect_to action: :index unless @agenda.processing?
  end
end
