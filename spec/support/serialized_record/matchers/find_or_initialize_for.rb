# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :find_or_initialize_for_serialized do |column, attributes:|
  match do |actual|
    column = column.to_s
    method_name = "find_or_initialize_#{column.singularize}_by"
    member_class = column.singularize.classify.constantize

    return false unless actual.respond_to?(method_name)
    return false unless finds_member?(actual, column, method_name, member_class, attributes)

    builds_member?(actual, column, method_name, attributes)
  end

  private

  def finds_member?(actual, column, method_name, member_class, attributes)
    member = member_class.new(**attributes)
    actual.public_send "#{column}=", [member]

    found_member = actual.public_send(method_name, attributes)

    return false unless actual.public_send(column).size == 1

    same_attributes?(member, found_member, attributes)
  end

  def builds_member?(actual, column, method_name, attributes)
    member = actual.public_send(method_name, attributes)
    members = actual.public_send(column)

    return false unless members.size == 1

    members[0] == member
  end

  def same_attributes?(member, found_member, attributes)
    attributes.keys.all? do |attribute|
      member.public_send(attribute) == found_member.public_send(attribute)
    end
  end
end
