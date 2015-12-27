module SerializedRecord::AcceptsNestedAttributeFor
  extend ActiveSupport::Concern

  module ClassMethods
    def serialized_accepts_nested_attributes_for(column)
      column = column.to_s
      klass = column.singularize.classify.constantize

      define_method "#{column}_attributes=" do |attributes|
        build_for klass, column, attributes.values
      end

      define_method "#{column}_altered?" do
        instance_variable_get("@#{column}_altered")
      end
    end
  end

  private

  def build_for(klass, column, attributes)
    members = attributes
                .reject { |member_attributes| member_attributes['_destroy'] }
                .collect { |member_attributes| klass.new(member_attributes.except('_create')) }

    public_send "#{column}=", members
    instance_variable_set "@#{column}_altered", alters_column?(attributes)
  end

  def alters_column?(attributes)
    attributes.any? do |member_attributes|
      %w(_create _destroy).any? { |action| member_attributes.keys.include?(action) }
    end
  end
end
