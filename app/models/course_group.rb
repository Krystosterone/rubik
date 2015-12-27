class CourseGroup
  include ActiveModel::Model

  attr_accessor :code, :group
  delegate :number, :periods, :overlaps?, to: :group

  def ==(other)
    code == other.code && group == other.group
  end
end
