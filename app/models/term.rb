# frozen_string_literal: true

class Term < ApplicationRecord
  has_many :academic_degree_terms,
           -> { joins(:academic_degree).order("academic_degrees.name DESC") },
           dependent: :destroy, inverse_of: :term
  has_many :academic_degrees, through: :academic_degree_terms

  validates :year, presence: true
  validates :name, presence: true, uniqueness: { scope: %i[year tags] }

  scope :enabled, -> { where.not(enabled_at: nil).order(year: :desc, name: :asc, tags: :asc) }
end
