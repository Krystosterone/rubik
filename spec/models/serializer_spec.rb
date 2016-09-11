# frozen_string_literal: true
require "rails_helper"

describe Serializer do
  class ConcreteSerializer < Serializer
    class << self
      def dump_as_json(value)
        value
      end

      def load_as_json(value)
        value
      end
    end
  end

  describe ConcreteSerializer do
    it_behaves_like "Serializer",
                    data_structure: { "one" => "two" },
                    as_json: { "one" => "two" }
  end
end
