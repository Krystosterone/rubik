class AgendaCourse
  include ActiveModel::Model

  attr_accessor :id, :code, :groups
  delegate :empty?, to: :groups

  class << self
    def from(academic_degree_term_course)
      new(
        id: academic_degree_term_course.id,
        code: academic_degree_term_course.code,
        groups: academic_degree_term_course.groups
      )
    end
  end

  def initialize(*)
    super
    @groups ||= []
  end

  def ==(other)
    return false unless id == other.id
    return false unless code == other.code
    groups == other.groups
  end
end
