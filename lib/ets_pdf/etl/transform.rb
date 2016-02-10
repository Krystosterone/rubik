class EtsPdf::Etl::Transform < Pipeline
  alias terms input

  def execute
    ActiveRecord::Base.transaction do
      terms.each { |arguments| TermUpdater.new(*arguments).execute }
    end
  end
end
