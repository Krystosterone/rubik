# frozen_string_literal: true

class Serializer
  class << self
    def dump(value)
      dump_as_json(value).to_json
    end

    def load(value)
      value.nil? ? [] : load_as_json(JSON.parse(value))
    end
  end
end
