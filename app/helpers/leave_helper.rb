module LeaveHelper
  def leave_times
    leaves = 7.times.collect do |day|
      (0..23).collect { |hour| WeekTime.on(day, hour) }
    end
    WeekTimeDecorator.decorate_collection(leaves.reduce(:concat))
  end
end
