class EtsPdf::Etl < Pipeline
  def initialize(pdf_folder)
    super(pdf_folder)
  end

  def execute
    pipe(PreProcess).pipe(Extract).pipe(Transform)
  end
end
