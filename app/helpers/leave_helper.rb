# frozen_string_literal: true
module LeaveHelper
  def leave_times
    leaves = Array.new(7) do |day|
      (0..23).collect { |hour| WeekTime.on(day, hour) }
    end
    WeekTimeDecorator.decorate_collection(leaves.reduce(:concat))
  end
end
