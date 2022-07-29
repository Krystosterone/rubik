# frozen_string_literal: true

class EtsPdf::Etl::PdfParser < SimpleClosure
  def initialize(txt_paths, buffer = File)
    super()
    @txt_paths = txt_paths
    @buffer = buffer
  end

  def call
    @txt_paths
      .map(&@buffer.method(:readlines))
      .map(&EtsPdf::Parser::ParsedDocumentFactory.method(:call))
  end
end
