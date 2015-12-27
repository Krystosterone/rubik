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
    course_set.each do |course|
      catch(:stop) do
        course.groups.each do |group|
          fail StopRecursion if course_groups.any? { |course_group| course_group.overlaps?(group) }

          new_course_groups = course_groups.dup
          new_course_groups << CourseGroup.new(code: course.code, group: group)
          next agenda.schedules.new(course_groups: new_course_groups) if add?(new_course_groups)

          begin
            iterate(course_set[1..-1], new_course_groups)
          rescue StopRecursion
            course_groups.empty? ? throw(:stop) : raise
          end
        end
      end
    end
  end

  def add?(course_groups)
    course_groups.size == agenda.courses_per_schedule
  end

  class StopRecursion < StandardError; end
end
