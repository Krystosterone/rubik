class AgendaCoursesValidator < ActiveModel::Validator
  def validate(agenda)
    if agenda.courses.empty?
      agenda.errors.add(:courses, :blank)
    elsif courses_mismatch?(agenda)
      agenda.errors.add(:courses, :greater_than_or_equal_to_courses_per_schedule)
    elsif mandatory_courses_overflow?(agenda)
      agenda.errors.add(:mandatory_course_codes, :less_than_or_equal_to_courses_per_schedule)
    elsif mandatory_courses_redundant?(agenda)
      agenda.errors.add(:mandatory_course_codes, :redundant)
    end
  end

  private

  def courses_mismatch?(agenda)
    agenda.courses.size < agenda.courses_per_schedule
  end

  def mandatory_courses_overflow?(agenda)
    agenda.courses_mandatory.size > agenda.courses_per_schedule
  end

  def mandatory_courses_redundant?(agenda)
    agenda.courses_mandatory.size == agenda.courses_per_schedule && agenda.courses_remainder.present?
  end
end
