# frozen_string_literal: true
class Agenda::Course < ActiveRecord::Base
  belongs_to :academic_degree_term_course
  belongs_to :agenda, inverse_of: :courses

  validates :academic_degree_term_course, presence: true

  delegate :code, :groups, to: :academic_degree_term_course

  scope :mandatory, -> { where(mandatory: true) }
  scope :optional, -> { where(mandatory: false) }

  after_initialize do
    self.mandatory = false if mandatory.nil?
  end

  def pruned_groups
    groups.reject(&method(:overlaps_leaves?))
  end

  private

  def overlaps_leaves?(group)
    agenda.leaves.any? do |leave|
      group.periods.any? { |period| leave.overlaps?(period) }
    end
  end
end
