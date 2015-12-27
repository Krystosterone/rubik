class Pipeline
  def initialize(input)
    @input = input
  end
  attr_reader :input

  def pipe(step)
    output = step.new(input).execute
    Pipeline.new(output)
  end
end
