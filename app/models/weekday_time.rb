# frozen_string_literal: true
class WeekdayTime
  def initialize(total_minutes)
    @total_minutes = total_minutes
  end
  attr_reader :total_minutes
  alias to_i total_minutes
  delegate :to_s, to: :total_minutes

  def hour
    @total_minutes / 60
  end

  def minutes
    @total_minutes % 60
  end

  def <=>(other)
    to_i <=> other.to_i
  end

  def ==(other)
    to_i == other.to_i
  end
end
