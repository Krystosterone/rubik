# frozen_string_literal: true

class EtsPdf::Etl::TermBuilder < SimpleClosure
  TERM_HANDLES = {
    "automne" => "Automne",
    "ete" => "Été",
    "hiver" => "Hiver",
  }.freeze

  def initialize(units)
    super()
    @units = units
  end

  def call
    @units
      .map(&method(:normalize_term_name))
      .group_by(&method(:group_terms))
      .each(&method(:create_term))
  end

  private

  def normalize_term_name(unit)
    term_name = TERM_HANDLES[unit[:term_handle]] ||
                raise("Invalid term handle '#{unit[:term_handle]}'")

    unit.except(:term_handle).merge(term_name: term_name)
  end

  def group_terms(unit)
    unit.slice(:term_name, :year)
  end

  def create_term(attributes, units)
    term_attributes = {
      name: attributes[:term_name],
      year: attributes[:year],
    }
    term = Term.where(term_attributes).first_or_create!

    EtsPdf::Etl::AcademicDegreeBuilder.call(
      term,
      units.map { |unit| unit.except(:term_name, :year) }
    )
  end
end
