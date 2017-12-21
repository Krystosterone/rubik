# frozen_string_literal: true

module SchedulePaginationHelper
  SCHEDULES_PER_PAGE = 20

  def schedule_page_index
    (@schedules.current_page - 1) * @schedules.limit_value
  end

  def schedule_index
    Integer(params.fetch(:index)) - 1
  end

  def schedule_page
    schedule_index / SCHEDULES_PER_PAGE + 1
  end
end
