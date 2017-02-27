# frozen_string_literal: true
class Agenda::Validator < ActiveModel::Validator
  def validate(agenda)
    MemoizedValidator.new(agenda).execute
  end

  class MemoizedValidator < SimpleDelegator
    include MemoizedCourseScopes

    def execute
      courses.each(&:validate)
      validate_courses
      validate_leaves
    end

    def validate_courses
      if courses.empty?
        errors.add(:courses, :blank)
      elsif courses_mismatch?
        errors.add(:courses, :greater_than_or_equal_to_courses_per_schedule)
      elsif mandatory_courses_overflow?
        errors.add(:courses, :mandatory_courses_less_than_or_equal_to_courses_per_schedule)
      elsif mandatory_courses_redundant?
        errors.add(:courses, :mandatory_courses_redundant)
      end
    end

    def validate_leaves
      errors.add(:leaves, :invalid) if leaves.map(&:invalid?).any?
    end

    def courses_mismatch?
      courses_per_schedule.present? && courses.size < courses_per_schedule
    end

    def mandatory_courses_overflow?
      courses_per_schedule.present? && mandatory_courses.size > courses_per_schedule
    end

    def mandatory_courses_redundant?
      mandatory_courses.size == courses_per_schedule && optional_courses.present?
    end

    def courses
      @courses ||= super.reject(&:marked_for_destruction?)
    end
  end
end
