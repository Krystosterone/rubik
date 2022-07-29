# frozen_string_literal: true

class EtsPdf::Etl::TermBuilder < SimpleClosure
  def initialize(documents)
    super()
    @documents = documents
  end

  def call
    @documents
      .map(&method(:extract_attributes))
      .each(&method(:create_term))
  end

  private

  def extract_attributes(document)
    term_line = document.term_line
    normalized_name = EtsPdf::TERM_NAMES.fetch(term_line.name.downcase)

    {
      name: normalized_name,
      year: term_line.year,
      document: document.except(:term),
    }
  end

  def create_term(attributes)
    term = Term.where(attributes.except(:document)).first_or_create!

    EtsPdf::Etl::AcademicDegreeBuilder.call(term, attributes.fetch(:document))
  end
end
