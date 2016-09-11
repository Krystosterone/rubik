# frozen_string_literal: true
class Period < WeekTimeRange
  include Draper::Decoratable
  attr_accessor :type

  def ==(other)
    type == other.type && super
  end
end
