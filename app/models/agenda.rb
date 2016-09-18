# frozen_string_literal: true
class Agenda < ActiveRecord::Base
  include SerializedRecord::AcceptsNestedAttributeFor

  COURSES_PER_SCHEDULE_RANGE = 1..5

  belongs_to :academic_degree_term
  has_one :academic_degree, through: :academic_degree_term
  has_one :term, through: :academic_degree_term
  has_many :academic_degree_term_courses, through: :academic_degree_term
  has_many :courses, dependent: :delete_all
  has_many :schedules, dependent: :delete_all

  accepts_nested_attributes_for :courses, allow_destroy: true

  serialize :leaves, LeavesSerializer
  serialized_accepts_nested_attributes_for :leaves

  validate :validate_leaves
  validates :courses_per_schedule, inclusion: { in: COURSES_PER_SCHEDULE_RANGE }
  validates_with AgendaCoursesValidator

  after_initialize do
    self.courses_per_schedule ||= COURSES_PER_SCHEDULE_RANGE.begin
    self.processing = false if processing.nil?
    self.token ||= SecureRandom.hex
  end

  alias_attribute :to_param, :token

  def combine
    mark_as_processing
    save.tap { |success| ScheduleGeneratorJob.perform_later(self) if success }
  end

  def mark_as_finished_processing
    self.processing = false
    self.combined_at = Time.zone.now
  end

  private

  def mark_as_processing
    self.processing = true
    self.combined_at = nil
  end

  def validate_leaves
    errors.add(:leaves, :invalid) if leaves.map(&:invalid?).any?
  end
end
