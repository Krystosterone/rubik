# frozen_string_literal: true

class Pipe
  class << self
    def bind(transformer)
      new([]).bind(transformer)
    end
  end

  def initialize(transformers)
    @transformers = transformers
  end

  def bind(transformer)
    self.class.new(@transformers + [transformer])
  end

  def call(value)
    @transformers.reduce(value) { |memo, transformer| transformer.call(memo) }
  end
end
