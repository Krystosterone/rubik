# frozen_string_literal: true

class AcademicDegreeTerm < ApplicationRecord
  belongs_to :academic_degree
  belongs_to :term, inverse_of: :academic_degree_terms
  has_many :academic_degree_term_courses, dependent: :destroy
  has_many :courses, through: :academic_degree_term_courses
  has_many :agendas, dependent: :destroy

  delegate :code, :name, to: :academic_degree

  scope :enabled, -> { joins(:term).where.not(terms: { enabled_at: nil }) }
end
