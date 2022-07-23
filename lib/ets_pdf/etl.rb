# frozen_string_literal: true

class EtsPdf::Etl < SimpleClosure
  def initialize(patterns = Dir.glob(Rails.root.join("db", "raw", "ets", "**", "*.pdf")))
    super()
    @patterns = patterns
  end

  def call
    Pipe.bind(PdfConverter).bind(PdfParser).bind(DomainBuilder).call(@patterns)
  end
end
