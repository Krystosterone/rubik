# frozen_string_literal: true

class EtsPdf::Etl::DomainBuilder
  class << self
    def call(documents)
      raise(ArgumentError, "At least one of the documents has no parsed lines") if documents.any?(&:empty?)

      ActiveRecord::Base.transaction { EtsPdf::Etl::TermBuilder.call(documents) }
    end
  end
end
