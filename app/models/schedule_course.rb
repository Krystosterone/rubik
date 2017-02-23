# frozen_string_literal: true
class ScheduleCourse < WeekdayTimeRange
  attr_accessor :code, :index, :number, :type

  def ==(other)
    return false unless code == other.code
    return false unless index == other.index
    return false unless number == other.number
    return false unless type == other.type
    super
  end
end
