class ScheduleCourse < WeekdayTimeRange
  attr_accessor :code, :index, :number, :type

  class << self
    def group_by_weekday_index(course_groups)
      Builder.new(course_groups).execute
    end
  end

  def ==(other)
    return false unless code == other.code
    return false unless index == other.index
    return false unless number == other.number
    return false unless type == other.type
    super
  end

  class Builder
    def initialize(course_groups)
      @course_groups = course_groups
    end

    def execute
      weekdays = (0..6).collect { |index| [index, []] }.to_h
      for_every_weekday_time_ranges do |weekday_index, course_group, period, weekday_time_range|
        weekdays[weekday_index] << ScheduleCourse.new(index: course_indexes[course_group.code],
                                                      code: course_group.code,
                                                      number: course_group.number,
                                                      type: period.type,
                                                      starts_at: weekday_time_range.starts_at,
                                                      ends_at: weekday_time_range.ends_at)
      end
      weekdays
    end

    private

    def course_indexes
      @course_indexes ||= @course_groups.each_with_index.collect do |course_group, index|
        [course_group.code, index + 1]
      end.to_h
    end

    def for_every_weekday_time_ranges
      @course_groups.each do |course_group|
        course_group.periods.each do |period|
          period.to_weekday_time_ranges.collect do |weekday_index, weekday_time_range|
            yield weekday_index, course_group, period, weekday_time_range
          end
        end
      end
    end
  end
end
