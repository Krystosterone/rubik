# frozen_string_literal: true
class EtsPdf::Etl::Transform < SimpleClosure
  def initialize(terms)
    @terms = terms
  end

  def call
    ActiveRecord::Base.transaction do
      @terms.each { |arguments| TermUpdater.new(*arguments).execute }
    end
  end
end
