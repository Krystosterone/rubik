class ScheduleGenerator
  def initialize(agenda)
    @agenda = agenda
  end

  def combine
    combinations.each do |course_set|
      iterate(course_set, [])
    end
  end

  private

  def combinations
    if @agenda.courses_mandatory.empty?
      @agenda.courses_pruned.combination(@agenda.courses_per_schedule)
    elsif @agenda.courses_mandatory.size == @agenda.courses_per_schedule
      @agenda.courses_pruned_mandatory.combination(@agenda.courses_per_schedule)
    else
      product_combinations
    end
  end

  def product_combinations
    remainder_set_size = @agenda.courses_per_schedule - @agenda.courses_mandatory.size
    mandatory_combinations = @agenda.courses_pruned_mandatory.combination(@agenda.courses_mandatory.size).to_a
    remainder_combinations = @agenda.courses_pruned_remainder.combination(remainder_set_size).to_a

    mandatory_combinations.product(remainder_combinations).map(&:flatten)
  end

  def iterate(course_set, course_groups)
    course = course_set.first
    course.groups.each do |group|
      next if course_groups.any? { |course_group| course_group.overlaps?(group) }

      new_course_groups = course_groups.dup
      new_course_groups << CourseGroup.new(code: course.code, group: group)

      complete_iteration(course_set, new_course_groups)
    end
  end

  def complete_iteration(course_set, course_groups)
    if course_set.size > 1
      iterate(course_set[1..-1], course_groups)
    elsif course_set.size == 1
      @agenda.schedules.new(course_groups: course_groups)
    end
  end
end
