# frozen_string_literal: true

class WeekdayTimeRange
  include ActiveModel::Model
  include ActiveModel::Validations

  validate :time_correctness

  def starts_at=(value)
    @starts_at = value.to_i
  end

  def starts_at
    WeekdayTime.new(@starts_at)
  end

  def ends_at=(value)
    @ends_at = value.to_i
  end

  def ends_at
    WeekdayTime.new(@ends_at)
  end

  def range
    @starts_at...@ends_at
  end

  def duration
    @ends_at - @starts_at
  end

  def overlaps?(other)
    range.overlaps?(other.range)
  end

  def empty?
    duration.zero?
  end

  def ==(other)
    starts_at == other.starts_at && ends_at == other.ends_at
  end

  private

  def time_correctness
    errors.add(:ends_at, :greater_than_or_equal_to_starts_at) if @ends_at <= @starts_at
  end
end
