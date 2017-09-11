# frozen_string_literal: true
class Agenda < ApplicationRecord
  include Defaults
  include SerializedRecord::AcceptsNestedAttributeFor

  COURSES_PER_SCHEDULE_RANGE = 1..5

  belongs_to :academic_degree_term
  has_one :academic_degree, through: :academic_degree_term
  has_one :term, through: :academic_degree_term
  has_many :academic_degree_term_courses, through: :academic_degree_term
  has_many :courses, autosave: true, dependent: :delete_all, inverse_of: :agenda
  has_many :schedules, dependent: :delete_all

  accepts_nested_attributes_for :courses, allow_destroy: true

  serialize :leaves, LeavesSerializer
  serialized_accepts_nested_attributes_for :leaves

  validates :academic_degree_term, presence: true
  with_options on: [AgendaCreationProcess::STEP_COURSE_SELECTION, AgendaCreationProcess::STEP_GROUP_SELECTION] do
    validates :courses, presence: true
    validates :courses_per_schedule, inclusion: { in: Agenda::COURSES_PER_SCHEDULE_RANGE }
    validates_with Validator
  end

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

  def assign_academic_degree_term(academic_degree:, term:)
    errors.add(:academic_degree, :blank) if academic_degree.nil?
    errors.add(:term, :blank) if term.nil?

    return if term.nil? || academic_degree.nil?
    self.academic_degree_term = AcademicDegreeTerm.find_by(academic_degree: academic_degree, term: term)
  end
end
