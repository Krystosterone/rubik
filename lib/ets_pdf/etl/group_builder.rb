# frozen_string_literal: true

class EtsPdf::Etl::GroupBuilder < SimpleClosure
  def initialize(academic_degree_term_course, parsed_lines)
    super()
    @academic_degree_term_course = academic_degree_term_course
    @parsed_lines = parsed_lines
  end

  def call
    @parsed_lines
      .each_with_object([], &method(:group_by_group_lines))
      .each(&method(:build_period))
  end

  private

  def group_by_group_lines(parsed_line, memo)
    if parsed_line.type?(:group)
      memo << [parsed_line]
    else
      memo.last << parsed_line
    end
  end

  def build_period(parsed_lines)
    group_line = parsed_lines[0]
    group_number = Integer(group_line.group.number.sub(/^0+/, ""))
    group = @academic_degree_term_course.find_or_initialize_group_by(number: group_number)

    EtsPdf::Etl::PeriodBuilder.call(group, parsed_lines)
  end
end
