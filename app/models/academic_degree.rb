# frozen_string_literal: true

class AcademicDegree < ApplicationRecord
  has_many :academic_degree_terms, dependent: :restrict_with_exception
  has_many :terms, through: :academic_degree_terms

  validates :code, presence: true, uniqueness: { case_sensitive: true }
  validates :name, presence: true
end
