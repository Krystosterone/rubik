# frozen_string_literal: true

require "rails_helper"

describe Serializer do
  describe ConcreteSerializer do
    it_behaves_like "Serializer",
                    data_structure: { "one" => "two" },
                    as_json: { "one" => "two" }
  end
end
