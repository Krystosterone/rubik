module ScheduleHelper
  def schedule_page_index
    (@schedules.current_page - 1) * @schedules.limit_value
  end

  def schedule_index
    Integer(params.fetch(:index)) - 1
  end
end
