# frozen_string_literal: true
class ScheduleCourseBuilder
  def initialize(course_groups)
    @course_groups = course_groups
  end

  def call
    weekdays = weekday_time_ranges.group_by { |weekday_index, *| weekday_index }
    weekdays = weekdays.transform_values(&method(:collect_values))
    (0..6).each { |index| weekdays[index] ||= [] }
    weekdays
  end

  private

  def course_indexes
    @course_indexes ||= @course_groups.each_with_index.collect do |course_group, index|
      [course_group.code, index + 1]
    end.to_h
  end

  def weekday_time_ranges
    @weekday_time_ranges ||= @course_groups.flat_map do |course_group|
      course_group.periods.flat_map do |period|
        period.to_weekday_time_ranges.collect do |weekday_index, weekday_time_range|
          [weekday_index, course_group, period, weekday_time_range]
        end
      end
    end
  end

  def collect_values(values)
    values.collect do |_, course_group, period, weekday_time_range|
      ScheduleCourse.new(
        index: course_indexes[course_group.code],
        code: course_group.code,
        number: course_group.number,
        type: period.type,
        starts_at: weekday_time_range.starts_at,
        ends_at: weekday_time_range.ends_at
      )
    end
  end
end
