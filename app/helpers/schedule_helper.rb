module ScheduleHelper
  SCHEDULES_PER_PAGE = 50

  def schedule_index
    (params.fetch(:page, 1).to_i - 1) * SCHEDULES_PER_PAGE
  end
end
