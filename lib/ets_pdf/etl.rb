# frozen_string_literal: true

class EtsPdf::Etl < SimpleClosure
  def initialize(pdf_folder = "db/raw/ets/**/*")
    super()
    @pdf_folder = pdf_folder
  end

  def call
    Pipe.bind(PdfConverter).bind(PdfParser).bind(DomainBuilder).call(@pdf_folder)
  end
end
