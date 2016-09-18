# frozen_string_literal: true
class TestStudent
  include ActiveModel::Model

  attr_accessor :name, :_destroy
end

class TestProfessor
  include ActiveModel::Model
  include SerializedRecord::FindOrInitializeFor
  include SerializedRecord::AcceptsNestedAttributeFor

  attr_accessor :test_students
  serialized_find_or_initialize_for :test_students
  serialized_accepts_nested_attributes_for :test_students

  def update(test_students:)
    @test_students = test_students
  end
end

class TestFormBuilder < ActionView::Helpers::FormBuilder
  include SerializedRecord::FormBuilderHelper
end
