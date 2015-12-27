class Course < ActiveRecord::Base
  has_many :academic_degree_term_courses
  has_many :academic_degree_terms, through: :academic_degree_term_courses

  validates :code, presence: true, uniqueness: true
end
