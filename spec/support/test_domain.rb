# frozen_string_literal: true

class TestStudent
  extend ActiveModel::Callbacks
  define_model_callbacks :initialize, only: :after

  include ActiveModel::Model
  include Defaults

  attr_accessor :name, :token, :_destroy

  default :name, "Krystian"
  default(:token) { SecureRandom.hex }

  def initialize(*)
    run_callbacks(:initialize) { super }
  end
end

class TestProfessor
  include ActiveModel::Model
  include SerializedRecord::FindOrInitializeFor
  include SerializedRecord::AcceptsNestedAttributeFor

  attr_accessor :test_students
  serialized_find_or_initialize_for :test_students
  serialized_accepts_nested_attributes_for :test_students
end

class TestFormBuilder < ActionView::Helpers::FormBuilder
  include SerializedRecord::FormBuilderHelper
end
