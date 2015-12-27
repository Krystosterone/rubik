class EtsPdf::Parser::ParsedLine
  class Course < Base
    def code
      @match_data[1]
    end

    private

    def match_pattern
      /^\f?((?:\w{3,4}EST)|(?:\w{3}\d{3}))/i
    end
  end
end
