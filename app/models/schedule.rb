# frozen_string_literal: true
class Schedule < ActiveRecord::Base
  belongs_to :agenda

  serialize :course_groups, CourseGroupsSerializer

  def starts_at
    @starts_at ||= weekdays.reject(&:empty?).min_by(&:starts_at).starts_at
  end

  def ends_at
    @ends_at ||= weekdays.reject(&:empty?).max_by(&:ends_at).ends_at
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
    @weekday_courses ||= ScheduleCourseBuilder.new(course_groups).call
  end

  def weekday_leaves
    @weekday_leaves ||= ScheduleLeaveBuilder.new(agenda.leaves).call
  end
end
