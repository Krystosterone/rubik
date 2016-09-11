# frozen_string_literal: true
class WeekTime < WeekdayTime
  class << self
    def on(day, hour)
      new(day * 24 * 60 + hour * 60)
    end
  end

  def hour
    super % 24
  end

  def weekday_index
    total_minutes / (60 * 24) % 7
  end
end
