class Student
  include ActiveModel::Model

  attr_accessor :name
end

class Professor
  include SerializedRecord::FindOrInitializeFor
  include SerializedRecord::AcceptsNestedAttributeFor

  attr_accessor :students
  serialized_find_or_initialize_for :students
  serialized_accepts_nested_attributes_for :students
end
