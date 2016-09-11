# frozen_string_literal: true
class EtsPdf::Parser::ParsedLine
  LINE_TYPES = %w(course group period).map do |type|
    [type, "EtsPdf::Parser::ParsedLine::#{type.classify}".constantize]
  end.to_h

  def initialize(line)
    @line = line
    @types = {}
  end
  attr_reader :line

  LINE_TYPES.each do |type, klass|
    define_method(type) { @types[type] ||= klass.new(@line) }
  end

  def parsed?
    LINE_TYPES.keys.any? { |type| type?(type) }
  end

  def type?(name)
    LINE_TYPES.keys.include?(name.to_s) ? public_send(name).parsed? : false
  end
end
