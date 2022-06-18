# frozen_string_literal: true

class EtsPdf::Etl::TermBuilder < SimpleClosure
  TERM_HANDLES = {
    "automne" => "Automne",
    "ete" => "Été",
    "hiver" => "Hiver",
  }.freeze
  TERM_TAGS = {
    "anciens" => "Anciens Étudiants",
    "nouveaux" => "Nouveaux Étudiants",
    "tous" => nil,
  }.freeze

  def initialize(units)
    super()
    @units = units
  end

  def call
    @units
      .map(&method(:normalize_term_name))
      .map(&method(:normalize_term_tags))
      .group_by(&method(:group_terms))
      .each(&method(:create_term))
  end

  private

  def normalize_term_name(unit)
    term_name = TERM_HANDLES[unit[:term_handle]] ||
                raise("Invalid term handle '#{unit[:term_handle]}'")

    unit.except(:term_handle).merge(term_name: term_name)
  end

  def normalize_term_tags(unit)
    term_tags = TERM_TAGS.key?(unit[:type]) ? TERM_TAGS[unit[:type]] : raise("Invalid bachelor type '#{unit[:type]}'")

    unit.except(:type).merge(term_tags: term_tags)
  end

  def group_terms(unit)
    unit.slice(:term_name, :term_tags, :year)
  end

  def create_term(attributes, units)
    term_attributes = {
      name: attributes[:term_name],
      tags: attributes[:term_tags],
      year: attributes[:year],
    }
    term = Term.where(term_attributes).first_or_create!

    EtsPdf::Etl::AcademicDegreeBuilder.call(
      term,
      units.map { |unit| unit.except(:term_name, :term_tags, :year) }
    )
  end
end
