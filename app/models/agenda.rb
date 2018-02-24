# frozen_string_literal: true

class Agenda < ApplicationRecord
  include Defaults
  include SerializedRecord::AcceptsNestedAttributeFor

  COURSES_PER_SCHEDULE_RANGE = 1..5

  belongs_to :academic_degree_term
  has_one :academic_degree, through: :academic_degree_term
  has_one :term, through: :academic_degree_term
  has_many :academic_degree_term_courses, through: :academic_degree_term
  has_many :courses, autosave: true, dependent: :destroy, inverse_of: :agenda
  has_many :schedules, dependent: :destroy

  accepts_nested_attributes_for :courses, allow_destroy: true

  serialize :leaves, LeavesSerializer
  serialized_accepts_nested_attributes_for :leaves

  validates :courses, presence: true
  validates :courses_per_schedule, inclusion: { in: Agenda::COURSES_PER_SCHEDULE_RANGE }
  validates_with Validator

  default :courses_per_schedule, COURSES_PER_SCHEDULE_RANGE.begin
  default :processing, false
  default(:token) { SecureRandom.hex }

  delegate :count, to: :schedules, prefix: true
  delegate :name, to: :academic_degree, prefix: true

  alias_attribute :to_param, :token

  def mark_as_finished_processing
    self.processing = false
    self.combined_at = Time.zone.now
  end
end
