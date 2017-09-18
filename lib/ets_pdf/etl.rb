# frozen_string_literal: true
class EtsPdf::Etl < SimpleClosure
  def initialize(pdf_folder = "db/raw/ets/**/*")
    @pdf_folder = pdf_folder
  end

  def call
    Pipe
      .bind(PreProcess)
      .bind(Extract)
      .bind(Transform)
      .call(@pdf_folder)
  end
end
