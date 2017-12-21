# frozen_string_literal: true

class AcademicDegree < ApplicationRecord
  has_many :academic_degree_terms, dependent: :restrict_with_exception
  has_many :terms, through: :academic_degree_terms # rubocop:disable Rails/InverseOf

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end
