module SerializedRecord::FindOrInitializeFor
  extend ActiveSupport::Concern

  module ClassMethods
    def serialized_find_or_initialize_for(column)
      column = column.to_s
      klass = column.singularize.classify.constantize

      define_method "find_or_initialize_#{column.singularize}_by" do |attributes|
        find_member(column, attributes) || build_member(klass, column, attributes)
      end
    end
  end

  private

  def find_member(column, attributes)
    public_send(column).find do |member|
      attributes.all? do |key, value|
        member.public_send(key) == value
      end
    end
  end

  def build_member(klass, column, attributes)
    member = klass.new(**attributes)
    public_send(column.to_s) << member
    member
  end
end
