class EtsPdf::Etl::Transform::GroupUpdater
  def initialize(academic_degree_term_course, group_data)
    @academic_degree_term_course = academic_degree_term_course
    @group_data = group_data
  end

  def execute
    group = @academic_degree_term_course.find_or_initialize_group_by(number: number)
    EtsPdf::Etl::Transform::PeriodUpdater.new(group, @group_data).execute
    group
  end

  private

  def number
    Integer(@group_data.number.sub(/^0+/, ''))
  end
end
