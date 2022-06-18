# frozen_string_literal: true

class Agenda::Course < ApplicationRecord
  include Defaults

  delegate :code, to: :academic_degree_term_course

  belongs_to :academic_degree_term_course
  belongs_to :agenda, inverse_of: :courses, touch: true

  serialize :group_numbers, JSON

  validates :selected_groups, presence: true

  scope :mandatory, -> { where(mandatory: true) }
  scope :optional, -> { where(mandatory: false) }

  default :group_numbers, []
  default :mandatory, false

  def academic_degree_term_course_groups
    academic_degree_term_course&.groups || []
  end

  def group_numbers=(value)
    super value.select(&:present?).map(&:to_i)
  end

  def pruned_groups
    selected_groups.reject(&method(:overlaps_leaves?))
  end

  def reset_group_numbers
    self.group_numbers = academic_degree_term_course.group_numbers
  end

  private

  def selected_groups
    academic_degree_term_course_groups.select { |group| group.number.in?(group_numbers) }
  end

  def overlaps_leaves?(group)
    agenda.leaves.any? do |leave|
      group.periods.any? { |period| leave.overlaps?(period) }
    end
  end
end
