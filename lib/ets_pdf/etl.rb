# frozen_string_literal: true
class EtsPdf::Etl < Pipeline
  def initialize(pdf_folder = "db/raw/ets/**/*")
    super(pdf_folder)
  end

  def execute
    pipe(PreProcess).pipe(Extract).pipe(Transform)
  end
end
