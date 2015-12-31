class Term < ActiveRecord::Base
  has_many :academic_degree_terms
  has_many :academic_degrees, through: :academic_degree_terms

  validates :year, presence: true
  validates :name, presence: true, uniqueness: { scope: [:year, :tags] }

  scope :ordered, lambda {
    includes(:academic_degree_terms, academic_degree_terms: :academic_degree)
      .order(year: :desc, name: :asc, tags: :asc)
  }
end
