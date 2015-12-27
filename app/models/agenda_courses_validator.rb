class AgendaCoursesValidator < ActiveModel::Validator
  def validate(agenda)
    if agenda.courses.empty?
      agenda.errors.add(:courses, :blank)
    elsif courses_mismatch?(agenda)
      agenda.errors.add(:courses, :greater_than_or_equal_to_courses_per_schedule)
    end
  end

  private

  def courses_mismatch?(agenda)
    agenda.courses.size < agenda.courses_per_schedule
  end
end
