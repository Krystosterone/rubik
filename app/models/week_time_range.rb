class WeekTimeRange < WeekdayTimeRange
  def starts_at
    WeekTime.new(super.to_i)
  end

  def ends_at
    WeekTime.new(super.to_i)
  end

  def to_weekday_time_ranges
    ranges =
      weekday_index_range.collect do |weekday_index|
        new_starts_at = [starts_at.to_i, 24 * 60 * weekday_index].max
        new_starts_at = new_starts_at % (24 * 60)

        new_ends_at = [ends_at.to_i, 24 * 60 * (weekday_index + 1)].min
        new_ends_at = new_ends_at % (24 * 60)
        new_ends_at = 24 * 60 unless weekday_index == weekday_index_range.end

        weekday_time_range = WeekdayTimeRange.new(starts_at: new_starts_at,
                                                  ends_at: new_ends_at)
        [weekday_index, weekday_time_range]
      end
    ranges.pop if ranges.last[1].empty?
    ranges.to_h
  end

  private

  def weekday_index_range
    starts_at.weekday_index..ends_at.weekday_index
  end
end
