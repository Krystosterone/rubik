# frozen_string_literal: true

class EtsPdf::Etl::AcademicDegreeBuilder < SimpleClosure
  BACHELOR_HANDLES = {
    "seg" => "Enseignements généraux",
    "ctn" => "Génie de la construction",
    "ele" => "Génie électrique",
    "log" => "Génie logiciel",
    "mec" => "Génie mécanique",
    "gol" => "Génie des opérations et de la logistique",
    "gpa" => "Génie de la production automatisée",
    "gti" => "Génie des technologies de l'information",
  }.freeze

  def initialize(term, units)
    super()
    @term = term
    @units = units
  end

  def call
    @units
      .map(&method(:normalize_bachelor_name))
      .group_by(&method(:group_by_academic_degree_attributes))
      .each(&method(:create_academic_degree))
  end

  private

  def normalize_bachelor_name(unit)
    bachelor_name = BACHELOR_HANDLES[unit[:bachelor_handle]] ||
                    raise("Invalid bachelor handle '#{unit[:bachelor_handle]}'")

    unit.merge(bachelor_name: bachelor_name)
  end

  def group_by_academic_degree_attributes(unit)
    unit.slice(:bachelor_handle, :bachelor_name)
  end

  def create_academic_degree(attributes, units)
    academic_degree_attributes = {
      code: attributes[:bachelor_handle],
      name: attributes[:bachelor_name],
    }
    academic_degree = AcademicDegree.where(academic_degree_attributes).first_or_create!
    academic_degree_term = @term.academic_degree_terms.create!(academic_degree: academic_degree)

    EtsPdf::Etl::AcademicDegreeTermCourseBuilder.call(
      academic_degree_term,
      units.flat_map { |unit| unit[:parsed_lines] }
    )
  end
end
