# frozen_string_literal: true

class EtsPdf::Etl::DomainBuilder
  class << self
    def call(units)
      ActiveRecord::Base.transaction { EtsPdf::Etl::TermBuilder.call(units) }
    end
  end
end
