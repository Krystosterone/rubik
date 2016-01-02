class TestStudent
  include ActiveModel::Model

  attr_accessor :name
end

class TestProfessor
  include SerializedRecord::FindOrInitializeFor
  include SerializedRecord::AcceptsNestedAttributeFor

  attr_accessor :test_students
  serialized_find_or_initialize_for :test_students
  serialized_accepts_nested_attributes_for :test_students
end

class TestFormBuilder < ActionView::Helpers::FormBuilder
  include SerializedRecord::FormBuilderHelper
end
