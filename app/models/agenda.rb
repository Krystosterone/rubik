class Agenda < ActiveRecord::Base
  include SerializedRecord::AcceptsNestedAttributeFor

  COURSES_PER_SCHEDULE_RANGE = 1..5

  belongs_to :academic_degree_term
  has_one :academic_degree, through: :academic_degree_term
  has_one :term, through: :academic_degree_term
  has_many :academic_degree_term_courses, through: :academic_degree_term
  has_many :schedules, dependent: :destroy

  serialize :courses, AgendaCoursesSerializer
  serialize :leaves, LeavesSerializer
  serialized_accepts_nested_attributes_for :leaves

  validate :validate_leaves
  validates :courses_per_schedule, inclusion: { in: COURSES_PER_SCHEDULE_RANGE }
  validates_with AgendaCoursesValidator

  attr_default :course_ids, []
  attr_default :courses_per_schedule, COURSES_PER_SCHEDULE_RANGE.begin
  attr_default(:token) { SecureRandom.hex }

  alias_attribute :to_param, :token
  delegate :empty?, to: :schedules

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

  def combine
    return false if leaves_altered?

    schedules.delete_all
    self.combined_at = nil
    save.tap { |success| ScheduleGeneratorJob.perform_later(self) if success }
  end

  def processing?
    !combined_at
  end

  private

  def validate_leaves
    errors.add(:leaves, :invalid) if leaves.map(&:valid?).any? { |valid| valid == false }
  end

  def find_courses(values)
    course_ids = values.select(&:present?).map(&:to_i)
    academic_degree_term.academic_degree_term_courses.find(course_ids)
  end
end
