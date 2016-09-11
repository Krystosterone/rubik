# frozen_string_literal: true
class Agenda < ActiveRecord::Base
  include SerializedRecord::AcceptsNestedAttributeFor

  COURSES_PER_SCHEDULE_RANGE = 1..5

  belongs_to :academic_degree_term
  has_one :academic_degree, through: :academic_degree_term
  has_one :term, through: :academic_degree_term
  has_many :academic_degree_term_courses, through: :academic_degree_term
  has_many :schedules, dependent: :delete_all

  serialize :courses, AgendaCoursesSerializer
  serialize :leaves, LeavesSerializer
  serialize :mandatory_course_ids, JSON
  serialized_accepts_nested_attributes_for :leaves

  validate :validate_leaves
  validates :courses_per_schedule, inclusion: { in: COURSES_PER_SCHEDULE_RANGE }
  validates_with AgendaCoursesValidator

  after_initialize do
    self.course_ids ||= []
    self.mandatory_course_ids ||= []
    self.courses_per_schedule ||= COURSES_PER_SCHEDULE_RANGE.begin
    self.processing ||= false
    self.token ||= SecureRandom.hex
  end

  alias_attribute :to_param, :token
  delegate :empty?, to: :schedules
  delegate :pruned, to: :courses, prefix: true
  delegate :mandatory, :remainder, to: :courses, prefix: true
  delegate :mandatory, :remainder, to: :courses_pruned, prefix: true

  def initialize(attributes = {})
    course_ids = attributes.delete(:course_ids)
    super
    self.course_ids = course_ids if course_ids.present?
  end

  def course_ids=(values)
    self.courses = find_courses(values).collect { |course| AgendaCourse.from(course) }
  end

  def course_ids
    courses.collect(&:id)
  end

  def courses
    AgendaCourseCollection.new(super, mandatory_course_ids, leaves)
  end

  def combine
    mark_as_processing
    save.tap { |success| ScheduleGeneratorJob.perform_later(self) if success }
  end

  def mark_as_finished_processing
    self.processing = false
    self.combined_at = Time.zone.now
  end

  def mandatory_course_ids=(values)
    super values.reject(&:blank?).map(&:to_i)
  end

  private

  def mark_as_processing
    self.processing = true
    self.combined_at = nil
  end

  def validate_leaves
    errors.add(:leaves, :invalid) if leaves.map(&:invalid?).any?
  end

  def find_courses(values)
    course_ids = values.select(&:present?).map(&:to_i)
    academic_degree_term.academic_degree_term_courses.find(course_ids)
  end
end
