# frozen_string_literal: true

class Period < WeekTimeRange
  attr_accessor :type

  def ==(other)
    type == other.type && super
  end
end
