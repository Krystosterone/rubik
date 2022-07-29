# frozen_string_literal: true

class EtsPdf::Parser::ParsedLine
  class Bachelor < Base
    def name
      @match_data[2]
    end

    private

    def match_pattern
      /(baccalauréat en|service des)\s+(#{EtsPdf::BACHELOR_HANDLES.keys.flatten.join("|")})/i
    end
  end
end
