# frozen_string_literal: true

class EtsPdf::Parser < SimpleClosure
  def initialize(path)
    super()
    @path = path
  end

  def call
    File.readlines(@path).collect { |line| ParsedLine.new(line) }
  end
end
