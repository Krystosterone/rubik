# frozen_string_literal: true

class EtsPdf::Etl < SimpleClosure
  def initialize(patterns = default_patterns)
    super()
    @patterns = patterns
  end

  def call
    Pipe.bind(PdfConverter).bind(PdfParser).bind(DomainBuilder).call(@patterns)
  end

  private

  def default_patterns
    Dir.glob(Rails.root.join("db", "raw", "ets", "**", "*.pdf"))
  end
end
