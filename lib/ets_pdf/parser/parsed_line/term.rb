# frozen_string_literal: true

class EtsPdf::Parser::ParsedLine
  class Term < Base
    def name
      @match_data[1]
    end

    def year
      @match_data[2]
    end

    private

    def match_pattern
      /horaire (#{EtsPdf::TERM_NAMES.keys.flatten.join("|")})\s+(\d{4})/i
    end
  end
end
