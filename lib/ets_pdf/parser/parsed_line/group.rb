# frozen_string_literal: true
class EtsPdf::Parser::ParsedLine
  class Group < Base
    %w(number weekday start_time end_time type).each_with_index do |attribute_name, index|
      define_method attribute_name do
        attributes[index]
      end
    end

    private

    def match_pattern
      %r{^\f?\s*(\d{1,2})\s*(\w{3})\s*(\d{2}:\d{2})\s-\s(\d{2}:\d{2})\s*(([\d\w\/\-\\+]+\s?)+)}i
    end

    def attributes
      @attributes ||= @match_data[1..5].collect(&:strip)
    end
  end
end
