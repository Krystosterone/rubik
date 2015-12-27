class UqamSite::Etl < Pipeline
  def initialize(options)
    super(options)
  end

  def execute
    pipe(Download)
  end
end
