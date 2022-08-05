# frozen_string_literal: true

class ScheduleCourse < WeekdayTimeRange
  attr_accessor :code, :index, :number, :type

  def ==(other)
    [code, index, number, type].hash == 
      [other.code, other.index, other.number, other.type].hash &&
      super
  end

  def hash
    [code, index, number, type].hash
  end
end
