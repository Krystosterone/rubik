class ScheduleCourse < WeekdayTimeRange
  attr_accessor :code, :index, :number, :type

  class << self
    def group_by_weekday_index(course_groups)
      weekdays = (0..6).collect { |index| [index, []] }.to_h
      course_indexes = indexes(course_groups)

      course_groups.each do |course_group|
        course_group.periods.each do |period|
          period.to_weekday_time_ranges.collect do |weekday_index, weekday_time_range|
            weekdays[weekday_index] <<
              ScheduleCourse.new(index: course_indexes[course_group.code],
                                 code: course_group.code,
                                 number: course_group.number,
                                 type: period.type,
                                 starts_at: weekday_time_range.starts_at,
                                 ends_at: weekday_time_range.ends_at)
          end
        end
      end

      weekdays
    end

    private

    def indexes(course_groups)
      course_groups.each_with_index.collect do |course_group, index|
        [course_group.code, index + 1]
      end.to_h
    end
  end

  def ==(other)
    return false unless code == other.code
    return false unless index == other.index
    return false unless number == other.number
    return false unless type == other.type
    super
  end
end
