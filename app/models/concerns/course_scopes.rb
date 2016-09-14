# frozen_string_literal: true
module CourseScopes
  extend ActiveSupport::Concern

  def courses
    AgendaCourseCollection.new(super, mandatory_course_ids, leaves)
  end

  def mandatory_courses
    courses.mandatory
  end

  def remainder_courses
    courses.remainder
  end

  def pruned_courses
    courses.pruned
  end

  def pruned_mandatory_courses
    courses.pruned.mandatory
  end

  def pruned_remainder_courses
    courses.pruned.remainder
  end
end
