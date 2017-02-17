# frozen_string_literal: true
class SchedulesController < ApplicationController
  include AgendaEagerLoading
  include ScheduleHelper

  before_action :find_agenda
  before_action :ensure_not_processing,
                :ensure_schedules_present, only: :index
  before_action :ensure_processing, only: :processing
  before_action :eager_load_courses, except: :processing
  skip_before_action :show_navigation, only: :processing

  decorates_assigned :agenda, :schedule, :schedules

  def index
    @schedules = find_schedules || raise(ActiveRecord::RecordNotFound)
  end

  def show
    @schedule = @agenda.schedules.offset(schedule_index).first!
  end

  def processing
    render :processing, status: :accepted
  end

  private

  def agenda_token
    params.require(:agenda_token)
  end

  def find_schedules
    @agenda.schedules.includes(:agenda).page(params[:page]).per(SCHEDULES_PER_PAGE).presence
  end

  def ensure_schedules_present
    return unless @agenda.schedules.empty?
    redirect_to edit_agenda_path(token: @agenda.token), flash: { notice: t(".blank_agenda") }
  end

  def ensure_not_processing
    redirect_to action: :processing if @agenda.processing?
  end

  def ensure_processing
    redirect_to action: :index unless @agenda.processing?
  end
end
