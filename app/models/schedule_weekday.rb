# frozen_string_literal: true

class ScheduleWeekday
  include ActiveModel::Model

  attr_accessor :index, :periods

  delegate :empty?, to: :periods

  def starts_at
    @starts_at ||= periods.min_by(&:starts_at).starts_at
  end

  def ends_at
    @ends_at ||= periods.max_by(&:ends_at).ends_at
  end

  def weekend?
    index.zero? || index == 6
  end

  def ==(other)
    index == other.index && periods == other.periods
  end
end
