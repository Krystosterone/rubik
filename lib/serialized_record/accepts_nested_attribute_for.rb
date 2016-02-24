module SerializedRecord::AcceptsNestedAttributeFor
  extend ActiveSupport::Concern

  module ClassMethods
    def serialized_accepts_nested_attributes_for(column)
      klass = column.to_s.singularize.classify.constantize

      define_method "#{column}_attributes=" do |attributes|
        members = attributes
                    .values
                    .collect { |member_attributes| klass.new(member_attributes) }
                    .reject(&:_destroy)
        update column => members
      end
    end
  end
end
