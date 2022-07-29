# frozen_string_literal: true

class EtsPdf::Parser::ParsedDocument
  class Error < StandardError; end
  class MismatchError < Error; end

  COMPARATORS = {
    term: ->(term) { [term.name, term.year] },
    bachelor: ->(bachelor) { bachelor.name },
  }.freeze

  attr_reader :parsed_lines

  delegate :empty?, to: :parsed_lines

  def initialize(parsed_lines)
    @parsed_lines = parsed_lines
  end

  def term_line
    @term_line ||= unique(:term)
  end

  def bachelor_line
    @bachelor_line ||= unique(:bachelor)
  end

  def except(type)
    @parsed_lines.reject { |line| line.type?(type) }.then(&self.class.method(:new))
  end

  private

  def unique(type)
    entity_lines = @parsed_lines.select { |line| line.type?(type) }.map(&type).uniq(&COMPARATORS.fetch(type))
    raise(MismatchError, "Parsed lines of type #{type} are not unique: #{entity_lines}") if entity_lines.size > 1

    entity_lines.first
  end
end
