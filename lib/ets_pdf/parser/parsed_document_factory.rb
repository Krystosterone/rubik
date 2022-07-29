# frozen_string_literal: true

module EtsPdf::Parser::ParsedDocumentFactory
  module_function

  def call(lines)
    lines
      .map(&EtsPdf::Parser::ParsedLine.method(:new))
      .select(&:parsed?)
      .then(&EtsPdf::Parser::ParsedDocument.method(:new))
  end
end
