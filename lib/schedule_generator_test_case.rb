# frozen_string_literal: true
class ScheduleGeneratorTestCase
  ACADEMIC_DEGREE_TERM_COURSE_ATTRIBUTES = %w(
    id
    groups
  ).freeze
  AGENDA_ATTRIBUTES = %w(
    courses_per_schedule
    leaves
    token
  ).freeze
  AGENDA_COURSE_ATTRIBUTES = %w(
    academic_degree_term_course_id
    group_numbers
    mandatory
  ).freeze
  COURSE_ATTRIBUTES = %w(
    code
  ).freeze

  mattr_accessor :folder_path, instance_accessor: false do
    Rails.root.join("spec", "support", "schedule_generator_test_cases")
  end

  class << self
    def all
      Dir[folder_path.join("**/*")].collect(&YAML.method(:load_file))
    end
  end

  def initialize(agenda_token)
    @agenda_token = agenda_token
  end

  def write
    File.write(file_path, file_content.to_yaml)
  end

  private

  def agenda
    @agenda ||= Agenda.find_by!(token: @agenda_token)
  end

  def file_path
    self.class.folder_path.join("#{agenda.token}.yml")
  end

  def file_content
    {
      academic_degree_term_courses_attributes: academic_degree_term_courses_attributes,
      agenda_attributes: agenda_attributes,
      generated_course_groups: generated_course_groups,
    }
  end

  def academic_degree_term_courses_attributes
    agenda.courses.map do |course|
      academic_degree_term_course = course.academic_degree_term_course

      attributes = course.academic_degree_term_course.slice(*ACADEMIC_DEGREE_TERM_COURSE_ATTRIBUTES).symbolize_keys
      attributes[:course_attributes] = academic_degree_term_course.course.slice(*COURSE_ATTRIBUTES).symbolize_keys
      attributes
    end
  end

  def agenda_attributes
    attributes = agenda.attributes.slice(*AGENDA_ATTRIBUTES).symbolize_keys
    attributes[:courses_attributes] = agenda_courses_attributes
    attributes
  end

  def agenda_courses_attributes
    agenda.courses.map { |course| course.attributes.slice(*AGENDA_COURSE_ATTRIBUTES).symbolize_keys }
  end

  def generated_course_groups
    agenda.schedules.collect(&:course_groups)
  end
end
