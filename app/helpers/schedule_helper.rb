module ScheduleHelper
  SCHEDULES_PER_PAGE = 50

  def schedule_index
    page = params.fetch(:page, 1).to_i
    page = [page - 1, 0].max
    page * SCHEDULES_PER_PAGE
  end
end
