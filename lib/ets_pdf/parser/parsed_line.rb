class EtsPdf::Parser::ParsedLine
  def initialize(line)
    @line = line
    @course = Course.new(line)
    @group = Group.new(line)
    @period = Period.new(line)
  end
  attr_reader :course, :group, :line, :period

  def type?(name)
    public_send(name).parsed?
  end

  def parsed?
    [@course, @group, @period].any?(&:parsed?)
  end
end
