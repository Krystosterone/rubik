class ScheduleGenerator
  def initialize(agenda)
    @agenda = agenda
  end
  attr_reader :agenda

  def combine
    pruned_courses.combination(agenda.courses_per_schedule).each do |course_set|
      iterate(course_set, [])
    end
    agenda.combined_at = Time.zone.now
  end

  private

  def pruned_courses
    agenda.courses.each(&method(:prune_groups)).reject(&:empty?)
  end

  def prune_groups(course)
    course.groups.reject! { |group| overlaps_leaves?(group) }
  end

  def overlaps_leaves?(group)
    agenda.leaves.any? do |leave|
      group.periods.any? { |period| leave.overlaps?(period) }
    end
  end

  def iterate(course_set, course_groups)
    course = course_set.first
    course.groups.each do |group|
      next if course_groups.any? { |course_group| course_group.overlaps?(group) }

      new_course_groups = course_groups.dup
      new_course_groups << CourseGroup.new(code: course.code, group: group)
      if add?(new_course_groups)
        agenda.schedules.new(course_groups: new_course_groups)
      elsif course_set.size > 1
        iterate(course_set[1..-1], new_course_groups)
      end
    end
  end

  def add?(course_groups)
    course_groups.size == agenda.courses_per_schedule
  end

  class StopRecursion < StandardError; end
end
