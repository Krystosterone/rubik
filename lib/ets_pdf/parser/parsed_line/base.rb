class EtsPdf::Parser::ParsedLine::Base
  def initialize(line)
    @match_data = match_pattern.match(line)
  end

  def parsed?
    @match_data
  end
end
