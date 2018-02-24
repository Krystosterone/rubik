# frozen_string_literal: true

class AcademicDegreeTerm < ApplicationRecord
  belongs_to :academic_degree
  belongs_to :term, inverse_of: :academic_degree_terms
  has_many :academic_degree_term_courses, dependent: :destroy
  has_many :courses, through: :academic_degree_term_courses
  has_many :agendas, dependent: :destroy

  validates :academic_degree, presence: true
  validates :term, presence: true

  delegate :code, :name, to: :academic_degree

  scope :enabled, -> { joins(:term).where("terms.enabled_at IS NOT NULL") }
end
