class Schedule < ActiveRecord::Base
  belongs_to :agenda

  serialize :course_groups, CourseGroupsSerializer

  def starts_at
    @starts_at ||= weekdays.reject(&:empty?).min { |a, b| a.starts_at <=> b.starts_at }.starts_at
  end

  def ends_at
    @ends_at ||= weekdays.reject(&:empty?).max { |a, b| a.ends_at <=> b.ends_at }.ends_at
  end

  def duration
    (ends_at.hour - starts_at.hour) * 60
  end

  def weekdays
    @weekdays ||= begin
      (0..6).collect do |index|
        periods = weekday_courses[index] + weekday_leaves[index]
        ScheduleWeekday.new(index: index, periods: periods)
      end
    end
  end

  private

  def weekday_courses
    @weekday_courses ||= ScheduleCourse.group_by_weekday_index(course_groups)
  end

  def weekday_leaves
    @weekday_leaves ||= ScheduleLeave.group_by_weekday_index(agenda.leaves)
  end
end
