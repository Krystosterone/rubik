# frozen_string_literal: true
class WeekdayTimeDecorator < Draper::Decorator
  delegate_all

  def time
    "#{hour}:#{minutes.to_s.rjust(2, '0')}"
  end
end
