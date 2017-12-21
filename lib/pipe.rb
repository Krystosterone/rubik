# frozen_string_literal: true

class Pipe
  class << self
    # rubocop:disable Rails/Delegate
    def bind(transformer)
      new([]).bind(transformer)
    end
    # rubocop:enable Rails/Delegate
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
