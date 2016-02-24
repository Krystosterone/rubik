module SerializedRecord
  module Matchers
    class AcceptNestedAttributesForSerialized
      def initialize(column, attributes:)
        @column = column.to_s
        @attributes = attributes.stringify_keys
      end

      def description
        "Test for `serialized_accepts_nested_attributes_for`"
      end

      def failure_message
        "Expected to define `serialized_accepts_nested_attributes_for`"
      end

      def failure_message_when_negated
        "Expected not to define `serialized_accepts_nested_attributes_for`"
      end

      def matches?(actual)
        return false unless builds_members?(actual)
        discards_destroyed_members?(actual)
      end

      private

      def builds_members?(actual, attributes = @attributes)
        attributes = { "0" => attributes }

        actual.public_send assign_attributes_method, attributes
        members = actual.public_send(@column)

        return false if attributes.values.size != members.size
        attributes.values.each_with_index.all? do |member_attributes, index|
          member = members[index]
          member.is_a?(klass) && attributes_match?(member, member_attributes)
        end
      end

      def builds_created_members?(actual)
        builds_members?(actual, @attributes.merge("_create" => "1")) &&
          alters_members?(actual)
      end

      def discards_destroyed_members?(actual)
        attributes = { "0" => @attributes.merge("_destroy" => "1") }

        actual.public_send assign_attributes_method, attributes
        members = actual.public_send(@column)

        members.empty?
      end

      def assign_attributes_method
        "#{@column}_attributes="
      end

      def klass
        @klass ||= @column.singularize.classify.constantize
      end

      def attributes_match?(member, member_attributes)
        member_attributes.except("_destroy").all? do |key, value|
          member.public_send(key) == value
        end
      end
    end

    def accept_nested_attributes_for_serialized(*args)
      AcceptNestedAttributesForSerialized.new(*args)
    end
  end
end

RSpec.configure { |config| config.include SerializedRecord::Matchers }
