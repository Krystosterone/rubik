class ScheduleWeekday
  include Draper::Decoratable
  include ActiveModel::Model

  attr_accessor :index, :periods
  delegate :empty?, to: :periods

  def starts_at
    @starts_at ||= periods.min { |a, b| a.starts_at <=> b.starts_at }.starts_at
  end

  def ends_at
    @ends_at ||= periods.max { |a, b| a.ends_at <=> b.ends_at }.ends_at
  end

  def weekend?
    index.zero? || index == 6
  end

  def ==(other)
    index == other.index && periods == other.periods
  end
end
