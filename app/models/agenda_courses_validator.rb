# frozen_string_literal: true
class AgendaCoursesValidator < ActiveModel::Validator
  def validate(agenda)
    Validator.new(agenda).execute
  end

  class Validator
    include MemoizedCourseScopes

    def initialize(agenda)
      @agenda = agenda
    end

    def execute
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

    private

    attr_reader :agenda
    delegate :errors, to: :agenda

    def courses_mismatch?
      courses.size < agenda.courses_per_schedule
    end

    def mandatory_courses_overflow?
      mandatory_courses.size > agenda.courses_per_schedule
    end

    def mandatory_courses_redundant?
      mandatory_courses.size == agenda.courses_per_schedule && optional_courses.present?
    end

    def courses
      @courses ||= agenda.courses.reject(&:marked_for_destruction?)
    end
  end
end
