# frozen_string_literal: true
class EtsPdf::Parser
  def initialize(path)
    @path = path
  end

  def execute
    File.readlines(@path).collect { |line| ParsedLine.new(line) }
  end
end
