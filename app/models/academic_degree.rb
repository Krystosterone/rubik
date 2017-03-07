# frozen_string_literal: true
class AcademicDegree < ApplicationRecord
  has_many :academic_degree_terms
  has_many :terms, through: :academic_degree_terms

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end
