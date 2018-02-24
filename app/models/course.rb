# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :academic_degree_term_courses, dependent: :restrict_with_exception
  has_many :academic_degree_terms, through: :academic_degree_term_courses

  validates :code, presence: true, uniqueness: true
end
