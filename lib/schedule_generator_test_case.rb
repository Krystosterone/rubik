class ScheduleGeneratorTestCase
  AGENDA_ATTRIBUTES = %w(
    courses_per_schedule
    courses
    leaves
    mandatory_course_codes
    token
  ).freeze

  mattr_accessor :folder_path, instance_accessor: false do
    Rails.root.join("spec/support/schedule_generator_test_cases")
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
    File.write file_path, file_content.to_yaml
  end

  private

  def agenda
    @agenda ||= Agenda.find_by!(token: @agenda_token)
  end

  def file_path
    self.class.folder_path.join("#{agenda.token}.yaml")
  end

  def file_content
    { agenda_attributes: attributes_to_commit.symbolize_keys,
      generated_course_groups: generated_course_groups }
  end

  def attributes_to_commit
    @agenda.attributes.slice(*AGENDA_ATTRIBUTES)
  end

  def generated_course_groups
    @agenda.schedules.collect(&:course_groups)
  end
end
