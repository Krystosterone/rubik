# frozen_string_literal: true

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

class SampleParsedLine < EtsPdf::Parser::ParsedLine::Base
  private

  def match_pattern
    /^valid line/
  end
end

class SimpleClosureImpl < SimpleClosure
  def call; end
end
