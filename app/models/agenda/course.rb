# frozen_string_literal: true
class Agenda::Course < ActiveRecord::Base
  include Defaults

  delegate :code, to: :academic_degree_term_course

  belongs_to :academic_degree_term_course
  belongs_to :agenda, inverse_of: :courses

  serialize :group_numbers, JSON

  validates :academic_degree_term_course, presence: true
  validates :selected_groups, presence: true

  scope :mandatory, -> { where(mandatory: true) }
  scope :optional, -> { where(mandatory: false) }

  default :mandatory, false

  def groups
    academic_degree_term_course.try!(:groups) || []
  end

  def group_numbers
    super || groups.map(&:number)
  end

  def group_numbers=(value)
    super value.select(&:present?).map(&:to_i)
  end

  def pruned_groups
    selected_groups.reject(&method(:overlaps_leaves?))
  end

  private

  def selected_groups
    groups.select(&method(:selected?))
  end

  def selected?(group)
    # TODO: Add test for filter_groups?
    !agenda.filter_groups? || group.number.in?(group_numbers)
  end

  def overlaps_leaves?(group)
    agenda.leaves.any? do |leave|
      group.periods.any? { |period| leave.overlaps?(period) }
    end
  end
end
